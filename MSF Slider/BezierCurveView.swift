//
//  BezierCurveView.swift
//  MSF Slider
//
//  Created by Franek on 07/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import UIKit

class TestViewController:UIViewController {
    
    var plot: Plot?
    
    var selectedPoint: Point?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.plot = Plot(frame: self.view.frame)
        self.view.addSubview(self.plot!)
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSingleTap))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch))
        self.view.addGestureRecognizer(pinchGestureRecognizer)
        
        
        self.view.backgroundColor = .green
        
    }
    
    @objc func didSingleTap(_ sender: UITapGestureRecognizer) {
    
        let location = sender.location(in: self.view)
        
        if let selectedPoint = self.view.hitTest(location, with: nil) as? Point {
            if let point = selectedPoint as? BezierPathPoint {
                point.isSelected =  !point.isSelected
            }
        } else {
            
            let point = BezierPathPoint(location)
            plot?.addPoint(point)
        }
    }
    
    @objc func didDoubleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        
        if let selectedPoint = self.view.hitTest(location, with: nil) as? Point {
            plot?.deletePoint(selectedPoint)
        } else {
        
        }
    }
    
    @objc func didPan(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        
        if sender.state == .began {
            if let selectedPoint = self.view.hitTest(location, with: nil) as? Point {
                self.selectedPoint = selectedPoint
                print(Date().timeIntervalSince1970)
            }
        } else if sender.state == .changed  {
            
            if let selectedPoint = self.selectedPoint {
                let location = sender.location(in: self.view)
                
                if let selectedPoint = selectedPoint as? ControlPoint {
//                    selectedPoint.move(to: location)
                    
                } else {
                
                plot?.movePoint(selectedPoint, to: location)
                }
            }
            
        } else if sender.state == .ended {
            self.selectedPoint = nil
        }
    }
    
    @objc func didPinch(_ sender: UIPinchGestureRecognizer) {
        let location = sender.location(in: self.view)
        
//        let point = Point(position: location)
//        point.backgroundColor = .red
//        self.view.addSubview(point)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implemented")
    }
}


class Plot: UIView{
    var points = [Point]()
    
    var pathLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.blue.cgColor
        pathLayer.lineWidth = 2.0
        self.layer.addSublayer(pathLayer)
    }
    
    override func draw(_ rect: CGRect) {
        guard !points.isEmpty else { return }
        let path = UIBezierPath()
        path.move(to: points[0].center)
        
        for point in points {
            path.addLine(to: point.center)
        }
        pathLayer.path = path.cgPath
    }
    
    func addPoint(_ point: Point) {
        guard !points.contains(point) else { return }
        self.addSubview(point)
        points.append(point)
        
        self.setNeedsDisplay()
    }
    
    func movePoint(_ point: Point, to destination: CGPoint) {
        point.moveTo(destination)
        self.setNeedsDisplay()
    }
    
    func modifyPoint(_ point: CGPoint) {
        
    }
    
    func deletePoint(_ point: Point) {
        point.removeFromSuperview()
        points = points.filter({$0 !== point})
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implemented")
    }
}

class BezierPathPoint: Point {
    var isSelected: Bool = true {
        didSet {
            isSelected ? self.becomeFirstResponder() : self.resignFirstResponder()
            controlPoint1?.isHidden = !isSelected
            controlPoint2?.isHidden = !isSelected
        }
    }
    
    var controlPoint1: ControlPoint?
    var controlPoint2: ControlPoint?

    override init(_ position: CGPoint) {
        super.init(position)
        self.controlPoint1 = ControlPoint(CGPoint(x: 100, y: 0), relativeTo: self.bounds.center, for: self)
        self.controlPoint2 = ControlPoint(CGPoint(x: 0, y: 100), relativeTo: self.bounds.center, for: self)
        self.addSubview(self.controlPoint1!)
        self.addSubview(self.controlPoint2!)
        backgroundColor = .orange
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implemented")
    }
}


class ControlPoint: Point {
    weak var parent: Point!
    var pathLayer = CAShapeLayer()
    
    init(_ position: CGPoint, relativeTo: CGPoint, for point: Point) {
        super.init(position + relativeTo)
        self.parent = point
        
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 3.0
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.gray.cgColor
        pathLayer.lineWidth = 1.0
        self.layer.addSublayer(pathLayer)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath()
        path.move(to: self.bounds.center)
        path.addLine(to: convert( parent.bounds.center , from: parent))
        pathLayer.path = path.cgPath
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implemented")
    }
}

class Point: UIView {
    var radius:CGFloat = 10
    
    init(_ position: CGPoint) {
        
        let frame = CGRect(x: position.x - radius, y: position.y - radius, width: radius*2, height: radius*2)
        super.init(frame: frame)
        
        self.backgroundColor = .black
        self.layer.cornerRadius = radius
    }
    
    func moveTo(_ position: CGPoint) {
        self.center = position
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let inset:CGFloat = -20
        let expandedBounds = self.bounds.insetBy(dx: inset , dy: inset)
        return expandedBounds.contains(point)
    }
}

