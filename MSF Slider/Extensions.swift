//
//  Extensions.swift
//  MSF Slider
//
//  Created by Franek on 29/04/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation
import UIKit



extension UIColor{
    static let backgroundGray = UIColor(white: 0.4, alpha: 1.0)
    static let barGray = UIColor(white: 0.3, alpha: 1.0)
    static let lighterOrange = UIColor(hue: 0.083, saturation: 0.8, brightness: 1.0, alpha: 1.0)
    
    
}


extension UIView {
    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
    
    var safeAreaRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        } else {
            return self.rightAnchor
        }
    }
    
    var safeAreaLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        } else {
            return self.leftAnchor
        }
    }
    
    var safeAreaLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
          return self.safeAreaLayoutGuide.leadingAnchor
        } else {
            return self.leadingAnchor
        }
    }
    
    var safeAreaTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.trailingAnchor
        } else {
            return self.trailingAnchor
        }
    }
}

extension CGRect {
    var center: CGPoint {
        get{
            return CGPoint(x: self.midX, y: self.midY)
        }
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        var rhs = rhs
        if rhs == 0 {
            rhs = CGFloat.leastNonzeroMagnitude
        }
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
    static func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs
    }
    
    static func -=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs - rhs
    }
    
    static func /=(lhs: inout CGPoint, rhs: CGFloat) {
        lhs = lhs / rhs
    }
    
    static func *=(lhs: inout CGPoint, rhs: CGFloat) {
        lhs = lhs * rhs
    }
    
    func distanceTo(_ point: CGPoint) -> CGFloat {
        let x = (self.x - point.x)
        let y = (self.y - point.y)
        
        return (x*x + y*y).squareRoot()
    }
    
    
    
    
    
    static func colinearTo(_ point: CGPoint, direction: CGPoint, distance: CGFloat) -> CGPoint {
        
        let direction = (direction-point)/direction.distanceTo(point)
        
        return point + direction*distance
        
    }
    
    
    
    
}
