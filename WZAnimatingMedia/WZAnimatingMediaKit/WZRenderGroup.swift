//
//  WZRenderGroup.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation

class WZRenderGroup: WZRenderNode {
    
    private(set) var containerLayer: WZLayer!
    private var opacityInterpolator: WZNumberInterpolator!
    private var transformInterpolator: WZTransformInterpolator!
    private(set) var rootNode: WZAnimationNode?
    
    init(inputNode: WZAnimationNode?, shapes: [WZShapeData], keyName: String) {
        super.init(inputNode: inputNode, keyName: keyName)
        
        containerLayer = WZLayer()

        buildContens(shapes: shapes)
    }
    
    private func buildContens(shapes: [WZShapeData]) {
        
        var previousNode: WZAnimationNode?
        
        for shape in shapes {
            
            if let shapeFillData = shape as? WZShapeFillData {
                let fillRenderer = WZFillRenderer(inputNode: previousNode, shapeFillData: shapeFillData)
                containerLayer.insert(fillRenderer.outputLayer, at: 0)
                previousNode = fillRenderer
            } else if let shapeGroupData = shape as? WZShapeGroupData {
                let renderGroup = WZRenderGroup(inputNode: previousNode, shapes: shapeGroupData.shapes, keyName: shapeGroupData.name)
                containerLayer.insert(renderGroup.containerLayer, at: 0)
                previousNode = renderGroup
            } else if let shapeRectangleData = shape as? WZShapeRectangleData {
                let rectAnimator = WZRoundedRectAnimator(inputNode: previousNode, shapeRectangleData: shapeRectangleData)
                previousNode = rectAnimator
            } else if let shapeStrokeData = shape as? WZShapeStrokeData {
                let strokeRenderer = WZStrokeRenderer(inputNode: previousNode, shapeStroke: shapeStrokeData)
                containerLayer.insert(strokeRenderer.outputLayer, at: 0)
                previousNode = strokeRenderer
            } else if let shapePathData = shape as? WZShapePathData {
               let shapePathAnimator = WZPathAnimator(inputNode: previousNode, shapePathData: shapePathData)
                previousNode = shapePathAnimator
            } else if let shapeTransformData = shape as? WZShapeTransformData {
                opacityInterpolator = WZNumberInterpolator(keyframes: shapeTransformData.opacity.keyframes)
                transformInterpolator = WZTransformInterpolator(position: shapeTransformData.position.keyframes, rotation: shapeTransformData.rotation.keyframes, anchor: shapeTransformData.anchor.keyframes, scale: shapeTransformData.scale.keyframes)

            }
        }
        
        rootNode = previousNode
    }
    
    override func update(frame: Int) {
        
        rootNode?.update(frame: frame)
    }
}
