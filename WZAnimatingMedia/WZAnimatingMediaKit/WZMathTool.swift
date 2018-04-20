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
}
