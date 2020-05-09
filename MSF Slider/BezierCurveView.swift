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
        
        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        
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
                plot?.selectedPoint = point
                
                
                
            }
            
            
            
        } else {
            if plot?.selectedPoint == nil {
                let point = BezierPathPoint(location)
                plot?.addPoint(point)
            } else {
                plot?.selectedPoint = nil
            }
            
        }
    }
    
    
    @objc func didDoubleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        
        if let selectedPoint = self.view.hitTest(location, with: nil) as? BezierPathPoint {
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
                
                if let controlPoint = selectedPoint as? ControlPoint {
                    plot?.movePoint(controlPoint, to: location)
                } else if let selectedPoint = selectedPoint as? BezierPathPoint {
                    plot?.movePoint(selectedPoint, to: location)
                }
            }
            
        } else if sender.state == .ended {
            self.selectedPoint = nil
        }
    }
    
    @objc func didPinch(_ sender: UIPinchGestureRecognizer) {
        //        let location = sender.location(in: self.view)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implemented")
    }
}


class Plot: UIView{
    var points = [BezierPathPoint]()
    
    
    var plotPathLayer = CAShapeLayer()
    var controlPathLayer = CAShapeLayer()
    
    weak var selectedPoint: BezierPathPoint? {
        willSet {
            if let newValue = newValue {
                newValue.isSelected = true
                
            }
            if let selectedPoint = selectedPoint {
                    selectedPoint.isSelected = false
                }
            }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        plotPathLayer.fillColor = UIColor.clear.cgColor
        plotPathLayer.strokeColor = UIColor.blue.cgColor
        plotPathLayer.lineWidth = 2.0
        self.layer.addSublayer(plotPathLayer)
        
        controlPathLayer.fillColor = UIColor.clear.cgColor
        controlPathLayer.strokeColor = UIColor.gray.cgColor
        controlPathLayer.lineWidth = 1.0
        self.layer.addSublayer(controlPathLayer)
    }
    
    override func draw(_ rect: CGRect) {
        plotPathLayer.path = nil
        guard points.count>1 else { return }
        
        let plotPath = UIBezierPath()
        plotPath.move(to: points[0].center)
        
        
        for i in 1...points.count-1 {
            if let controlPoint1 = points[i-1].controlPoint2, let controlPoint2 = points[i].controlPoint1 {
                plotPath.addCurve(to: points[i].center, controlPoint1: controlPoint1.center, controlPoint2: controlPoint2.center)
            }
        }
        plotPathLayer.path = plotPath.cgPath
        
        
    }
    
    func addPoint(_ point: BezierPathPoint) {
        guard !points.contains(point) else { return }
        
        if let i = points.firstIndex(where: {$0.center.x > point.center.x}) {
            points.insert(point, at: i)
        } else  {
            points.append(point)
        }
        
        let i = points.firstIndex(of: point)!
        
        switch points.count {
        case 1:
            break
        case 2:
            points[0].controlPoint2 = ControlPoint.inDirection(of: points[1], for: points[0])
            self.addSubview(points[0].controlPoint2!)
            points[1].controlPoint1 = ControlPoint.inDirection(of: points[0], for: points[1])
            self.addSubview(points[1].controlPoint1!)
            
        default:
            if point == points.first {
                point.controlPoint2 = ControlPoint.inDirection(of: points[1], for: point)
                self.addSubview(point.controlPoint2!)
                ControlPoint.smoothBetween(previous: point, next: points[i+2], for: &points[i+1])
                self.addSubview(points[i+1].controlPoint1!)
                self.addSubview(points[i+1].controlPoint2!)
                
            } else if point == points.last {
                point.controlPoint1 = ControlPoint.inDirection(of: points[points.count-2], for: point)
                self.addSubview(point.controlPoint1!)
                ControlPoint.smoothBetween(previous: points[i-2], next: point, for: &points[i-1])
                self.addSubview(points[i-1].controlPoint1!)
                self.addSubview( points[i-1].controlPoint2!)
            } else {
                ControlPoint.smoothBetween(previous: points[i-1], next: points[i+1], for: &points[i])
                
                self.addSubview(point.controlPoint1!)
                
                self.addSubview(point.controlPoint2!)
                
            }
            //            {
            //                points[1].controlPoint1 = ControlPoint(points[1].center - CGPoint(x: 100, y: 100), for: points[1])
            //                self.addSubview(points[1].controlPoint1!)
            //            }
            //             else {
            //                let i = points.count-2
            //                points[i].controlPoint2 = ControlPoint(points[i].center - CGPoint(x: 100, y: 100), for: points[i])
            //                self.addSubview(points[i].controlPoint2!)
            //            }
            
            
        }
        
        self.addSubview(point)
        self.setNeedsDisplay()
    }
    
    func movePoint(_ point: BezierPathPoint, to destination: CGPoint) {
        
        let i = points.firstIndex(of: point)!
        
        var validatedDestination = destination
        
        if i > 0 {
            let previous = points[i-1]
            if destination.x < previous.center.x {
                validatedDestination.x = previous.center.x
            }
        }
        
        if i < points.count-1 {
            let previous = points[i+1]
            if destination.x > previous.center.x {
                validatedDestination.x = previous.center.x
            }
        }
        
        
       
        
        
        if let controlPoint1 = point.controlPoint1 {
            controlPoint1.moveTo(validatedDestination + controlPoint1.relativePosition)
        }
        
        if let controlPoint2 = point.controlPoint2 {
            controlPoint2.moveTo(validatedDestination + controlPoint2.relativePosition)
        }
        
        
        point.moveTo(validatedDestination)
        
        self.setNeedsDisplay()
    }
    
    func movePoint(_ controlPoint: ControlPoint, to destination: CGPoint) {
        
        
        let secondControlPoint: ControlPoint?
        var validatedDestination = destination
        if controlPoint === controlPoint.parent.controlPoint1 {
            secondControlPoint = controlPoint.parent.controlPoint2
            if destination.x > controlPoint.parent.center.x {
                validatedDestination.x = controlPoint.parent.center.x
            }
        } else {
            secondControlPoint = controlPoint.parent.controlPoint1
            if destination.x < controlPoint.parent.center.x {
                validatedDestination.x = controlPoint.parent.center.x
            }
        }
        
        let minDistanceFromParent:CGFloat = 20
        if validatedDestination.distanceTo(controlPoint.parent.center) < minDistanceFromParent {
            let y = validatedDestination.y - controlPoint.parent.center.y
            
            validatedDestination.x = controlPoint.parent.center.x + (minDistanceFromParent*minDistanceFromParent-y*y).squareRoot()
        }
        controlPoint.moveTo(validatedDestination)
        
        if let secondControlPoint = secondControlPoint {
            let distance = secondControlPoint.center.distanceTo(controlPoint.parent.center)
            let newPosition = CGPoint.colinearTo(controlPoint.parent.center, direction: controlPoint.center, distance: -distance)
            secondControlPoint.moveTo(newPosition)
        }
        
        self.setNeedsDisplay()
    }
    
    func modifyPoint(_ point: CGPoint) {
        
    }
    
    func deletePoint(_ point: BezierPathPoint) {
        guard points.contains(point) else { return }
        
        switch points.count {
        case 1:
            break
        case 2:
            
            if point != points.first {
                points[0].controlPoint2 = nil
            } else {
                points[1].controlPoint1 = nil
            }
            
        default:
            
            if point == points.last {
                points[points.count-2].controlPoint2 = nil
                point.controlPoint1 = nil
            } else if point == points.first {
                points[1].controlPoint1 = nil
                points[1].controlPoint1 = nil
                point.controlPoint2 = nil
            }
        }
        
        point.controlPoint1 = nil
        point.controlPoint2 = nil
        
        points = points.filter({$0 !== point})
        
        point.removeFromSuperview()
        self.setNeedsDisplay()
    }
    
    //    func deletePoint(_ controlPoint: ControlPoint?) {
    //        controlPoint.
    //    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implemented")
    }
}

class BezierPathPoint: Point {
    
    var isSelected: Bool = false {
        didSet {
            controlPoint1?.isHidden = !isSelected
            controlPoint2?.isHidden = !isSelected
        }
    }
    
    var controlPoint1: ControlPoint? {
        willSet {
            controlPoint1?.removeFromSuperview()
        }
    }
    var controlPoint2: ControlPoint? {
        willSet {
            controlPoint2?.removeFromSuperview()
        }
    }
    
    override init(_ position: CGPoint) {
        super.init(position)
        
        backgroundColor = .orange
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implemented")
    }
}


class ControlPoint: Point {
    static func inDirection(of point: BezierPathPoint, for parent: BezierPathPoint) -> ControlPoint {
        let direction = (point.center - parent.center) / parent.center.distanceTo(point.center)
        let position = parent.center + direction * 30
        return ControlPoint(position, for: parent)
    }
    
    static func smoothBetween(previous: BezierPathPoint, next: BezierPathPoint, for parent: inout BezierPathPoint) {
        let distance1 = (previous.center - parent.center)/2
        let controlPoint1 = ControlPoint(parent.center + CGPoint(x: distance1.x, y: 0), for: parent)
        let distance2 = (next.center - parent.center)/2
        let controlPoint2 = ControlPoint(parent.center + CGPoint(x: distance2.x, y: 0), for: parent)
        
        parent.controlPoint1 = controlPoint1
        parent.controlPoint2 = controlPoint2
    }
    
    
    weak var parent: BezierPathPoint!
    var relativePosition: CGPoint {
        return self.center - parent.center
    }
    var pathLayer = CAShapeLayer()
    
    init(_ position: CGPoint, for point: BezierPathPoint) {
        super.init(position)
        self.parent = point
        self.isHidden = true
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
        
        let path = CGMutablePath()
        path.move(to: superview!.convert(self.center, to: self))
        path.addLine(to: superview!.convert(self.parent.center, to: self))
        
        pathLayer.path = path
    }
    
    override func moveTo(_ position: CGPoint) {
        super.moveTo(position)
        self.setNeedsDisplay()
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

