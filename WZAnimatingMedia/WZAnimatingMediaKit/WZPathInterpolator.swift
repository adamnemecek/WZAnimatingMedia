//
//  WZPathInterpolator.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/25.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit

class WZPathInterpolator: WZValueInterpolator {
    
    func path(at frame: Double) -> WZBezierPath {
        
        let path = WZBezierPath()
        
        let bezierData = keyframes.first!.beizerData
        
        var outTangent: CGPoint!
        var inTangent: CGPoint!
        var vertex: CGPoint!
        var startVertex: CGPoint!
        var startInTangent: CGPoint!
        var previousOutTangent: CGPoint!
        
        for i in 0..<bezierData.count {
        
            vertex = bezierData.vertices[i]
            inTangent = bezierData.inTangents[i]
            outTangent = bezierData.outTangents[i]
            
            if i == 0 {
                startVertex = vertex
                startInTangent = inTangent
                path.move(to: vertex)
            } else {
                path.addCurve(endPoint: vertex, controlPoint1: previousOutTangent, controlPoint2: inTangent)
            }
            
            previousOutTangent = outTangent
        }
        
        if bezierData.closed {
            path.addCurve(endPoint: startVertex, controlPoint1: previousOutTangent, controlPoint2: startInTangent)
        }
        
        return path
    }
}
