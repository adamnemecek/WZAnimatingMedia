//
//  WZTransformInterpolator.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation

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
}
