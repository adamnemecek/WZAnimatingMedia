//
//  WZFillRenderer.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation

class WZFillRenderer: WZRenderNode {
    
    private var colorInterpolator: WZColorInterpolator
    private var opacityInterpolator: WZNumberInterpolator
    private var evenOddFillRule: Bool
    
    init(inputNode: WZAnimationNode?, shapeFillData: WZShapeFillData) {
        
        colorInterpolator = WZColorInterpolator(keyframes: shapeFillData.color.keyframes)
        opacityInterpolator = WZNumberInterpolator(keyframes: shapeFillData.opacity.keyframes)
        evenOddFillRule = shapeFillData.evenOddFillRule
        
        super.init(inputNode: inputNode, keyName: shapeFillData.name)
        
        outputLayer.fillRule = evenOddFillRule ? "even-odd" : "non-zero"
    }
    
    override func performUpdate() {
        super.performUpdate()
        
        outputLayer.fillColor = 0xFFFF00
        outputLayer.path = inputNode!.inputNode!.localPath
    }
}
