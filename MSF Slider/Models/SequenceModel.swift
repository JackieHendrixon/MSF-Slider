//
//  SequenceModel.swift
//  MSF Slider
//
//  Created by Franek on 10/05/2020.
//  Copyright © 2020 Frankie. All rights reserved.
//

import Foundation

class SequenceModel {
    var keyframes = [Keyframe]()
    
    func valueFor(frame: Int) -> Float {
        guard !keyframes.isEmpty else {fatalError()}
        guard frame > 0 else { fatalError()}
        guard frame < keyframes.last!.frame else {fatalError()}
        
        if let result = (keyframes.first{$0.frame==frame})?.value {
            return result
        } else {
            if let preceding = keyframes.last(where: {$0.frame<frame}), let following = keyframes.first(where: {$0.frame>frame}) {
                if let c1 = preceding.controlPoint2, let c2 = following.controlPoint1 {
                    let c0 = Point(x: Float(preceding.frame), y: preceding.value)
                    let c3 = Point(x: Float(following.frame), y: preceding.value)
                    return Math.calcuatePointsOnBezierCurve(for: Float(frame), c0: c0, c1: c1, c2: c2, c3: c3)[0].x
                }
            }
        }
        
        fatalError()
        
    }
}

struct Keyframe {
    var frame: Int
    var value: Float
    var controlPoint1: Point?
    var controlPoint2: Point?
}

struct Point {
    var x: Float
    var y: Float
}
