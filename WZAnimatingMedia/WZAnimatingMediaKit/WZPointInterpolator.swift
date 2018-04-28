//
//  WZPointInterpolator.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit

class WZPointInterpolator: WZValueInterpolator {
    
    func pointValue(at frame: Double) -> CGPoint {
        
        let progressInfo = calculateProgress(at: frame)
        
        let pointAtFrame: CGPoint

        switch progressInfo {
        case .endpoint(keyframe: let keyframe):
            pointAtFrame = keyframe?.pointValue ?? .zero
        case .middle(progress: let progress, leadingKeyframe: let leadingKeyframe, trailingKeyframe: let trailingKeyframe):
            
            let spatialInTangent = trailingKeyframe.spatialInTangent
            let spatialOutTangent = leadingKeyframe.spatialOutTangent
            
            if spatialInTangent == .zero && spatialOutTangent == .zero {
                pointAtFrame = WZMathTool.pointInLine(startPoint: leadingKeyframe.pointValue, endPoint: trailingKeyframe.pointValue, percent: progress)
            } else {
                let outTan = leadingKeyframe.pointValue + leadingKeyframe.spatialOutTangent
                let inTan = trailingKeyframe.pointValue + trailingKeyframe.spatialInTangent
                pointAtFrame = WZMathTool.pointInCubic(startPoint: leadingKeyframe.pointValue, controlPoint1: outTan, controlPoint2: inTan, endPoint: trailingKeyframe.pointValue, t: progress)
            }
        }
        
        return pointAtFrame
    }
}
