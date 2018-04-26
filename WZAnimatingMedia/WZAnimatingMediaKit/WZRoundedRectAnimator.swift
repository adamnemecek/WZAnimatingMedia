//
//  WZRoundedRectAnimator.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation

class WZRoundedRectAnimator: WZAnimationNode {
    
    private var centerInterpolator: WZPointInterpolator
    private var sizeInterpolator: WZPointInterpolator
    private var cornerRadiusInterpolator: WZNumberInterpolator
    private var reversed:Bool
    
    init(inputNode: WZAnimationNode?, shapeRectangleData: WZShapeRectangleData) {
        
        self.centerInterpolator = WZPointInterpolator(keyframes: shapeRectangleData.position.keyframes)
        self.sizeInterpolator = WZPointInterpolator(keyframes: shapeRectangleData.size.keyframes)
        self.cornerRadiusInterpolator = WZNumberInterpolator(keyframes: shapeRectangleData.cornerRadius.keyframes)
        self.reversed = shapeRectangleData.reversed
        
        super.init(inputNode: inputNode, keyName: shapeRectangleData.name)
        
    }
}
