//
//  MathTool.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/20.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit

class WZMathTool {
    
    static func remapValue(value: CGFloat, low1: CGFloat, high1: CGFloat, low2: CGFloat, high2: CGFloat) -> CGFloat {
        return low2 + (value - low1) / (high1 - low1) * (high2 - low2)
    }
    
    static func degreesToRadians(degress: CGFloat) -> CGFloat {
        return degress / 180 * CGFloat(Double.pi)
    }
    
    static func pointInLine(startPoint: CGPoint, endPoint: CGPoint, percent: CGFloat) -> CGPoint {
        
        let x = startPoint.x + (endPoint.x - startPoint.x) * percent
        let y = startPoint.y + (endPoint.y - startPoint.y) * percent
        
        return CGPoint(x: x, y: y)
    }
    
    static func pointInCubic(startPoint a: CGPoint, controlPoint1 p1: CGPoint, controlPoint2 p2: CGPoint, endPoint b: CGPoint, t: CGFloat) -> CGPoint {
        
        let nt = 1.0 - t
        
        let x = a.x * nt * nt * nt  +  3.0 * p1.x * nt * nt * t  +  3.0 * p2.x * nt * t * t  +  b.x * t * t * t
        let y = a.y * nt * nt * nt  +  3.0 * p1.y * nt * nt * t  +  3.0 * p2.y * nt * t * t  +  b.y * t * t * t
        
        return CGPoint(x: x, y: y)

    }
}
