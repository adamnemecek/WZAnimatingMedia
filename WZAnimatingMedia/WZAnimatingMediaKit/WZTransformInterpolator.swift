//
//  WZTransformInterpolator.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit

class WZTransformInterpolator {
    
    private var positionInterpolator: WZPointInterpolator
    private var anchorInterpolator: WZPointInterpolator
    private var scaleInterpolator: WZSizeInterpolator
    private var rotationInterpolator: WZNumberInterpolator
    
    var keyName = ""
    
    init(position: [WZKeyframe], rotation: [WZKeyframe], anchor: [WZKeyframe], scale: [WZKeyframe]) {
        
        positionInterpolator = WZPointInterpolator(keyframes: position)
        anchorInterpolator = WZPointInterpolator(keyframes: anchor)
        scaleInterpolator = WZSizeInterpolator(keyframes: scale)
        rotationInterpolator = WZNumberInterpolator(keyframes: rotation)
        
    }
    
    func transform(at frame: Double) -> CATransform3D {
        
        let position = positionInterpolator.pointValue(at: frame)
        var transform = CATransform3DTranslate(CATransform3DIdentity, position.x, position.y, 0)
        
        return transform
    }
}
