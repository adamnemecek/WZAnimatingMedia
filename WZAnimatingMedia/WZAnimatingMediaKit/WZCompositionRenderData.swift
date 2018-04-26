//
//  WZRenderData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation

class WZCompositionRenderData: WZLayerRenderData {
    
    private(set) var childLayers: [WZLayerRenderData] = []
    
    override init(layer: WZLayerData?, layerGroup: WZLayerGroupData) {
        super.init(layer: layer, layerGroup: layerGroup)
        
        for layerData in layerGroup.layerDatas.reversed() {
            
            let child = WZLayerRenderData(layer: layerData, layerGroup: layerGroup)
            
            childLayers.append(child)
            wrapperLayer.add(child)

        }
    }
}
