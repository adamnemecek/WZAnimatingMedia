//
//  WZLayerRenderData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation

class WZLayerRenderData: WZLayer {
    
    private(set) var wrapperLayer = WZLayer()
    private var layerName = ""
    private var inFrame = 0
    private var outFrame = 0
    private var timeStretch = 0
    private var transformInterpolator: WZTransformInterpolator!
    private var opacityInterpolator: WZNumberInterpolator!
    private(set) var renderGroup: WZRenderGroup!
    
    init(layer: WZLayerData?, layerGroup: WZLayerGroupData) {
        super.init()
        
        add(wrapperLayer)
        guard let layerData = layer else { return }
        
        layerName = layerData.name
        inFrame = layerData.inFrame
        outFrame = layerData.outFrame
        timeStretch = layerData.timeStretch
        transformInterpolator = WZTransformInterpolator(position: layerData.position.keyframes,
                                                        rotation: layerData.rotation.keyframes,
                                                        anchor: layerData.anchor.keyframes,
                                                        scale: layerData.scale.keyframes)
        transformInterpolator.keyName = layerData.name
        
        opacityInterpolator = WZNumberInterpolator(keyframes: layerData.opacity.keyframes)
        
        if layerData.type == .shape && !layerData.shapes.isEmpty {
            buildContent(shapes: layerData.shapes)
        }
    }
    
    private func buildContent(shapes: [WZShapeData]) {
        
        renderGroup = WZRenderGroup(inputNode: nil, shapes: shapes, keyName: layerName)
        wrapperLayer.add(renderGroup.containerLayer)
    }
}
