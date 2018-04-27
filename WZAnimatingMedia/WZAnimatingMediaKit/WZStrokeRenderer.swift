//
//  WZStrokeRenderer.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation

class WZStrokeRenderer: WZRenderNode {
    
    private var colorInterpolator: WZColorInterpolator
    private var opacityInterpolator: WZNumberInterpolator
    private var widthInterpolator: WZNumberInterpolator
    
    init(inputNode: WZAnimationNode?, shapeStroke: WZShapeStrokeData) {
        
        self.colorInterpolator = WZColorInterpolator(keyframes: shapeStroke.color.keyframes)
        self.opacityInterpolator = WZNumberInterpolator(keyframes: shapeStroke.opacity.keyframes)
        self.widthInterpolator = WZNumberInterpolator(keyframes: shapeStroke.width.keyframes)
        
        super.init(inputNode: inputNode, keyName: shapeStroke.name)
        
        //TODO: linecap and line join
    }
    
    override func performUpdate() {
        super.performUpdate()
        
        outputLayer.strokeColor = colorInterpolator.color(at: currentFrame)
        outputLayer.lineWidth = 14
    }
    
    override func rebuildOutputs() {
        outputLayer.path = inputNode?.outputPath
    }
}
