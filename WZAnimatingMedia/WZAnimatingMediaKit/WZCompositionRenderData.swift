//
//  WZRenderData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit

class WZCompositionRenderData {
    
    private(set) var childLayers: [WZLayerRenderData] = []
    
    init(layerGroup: WZLayerGroupData) {
        
        for layerData in layerGroup.layerDatas.reversed() {
            
            let child = WZLayerRenderData(layerData: layerData, layerGroup: layerGroup)
            
            childLayers.append(child)

        }
    }
    
    func update(frame: Double) {
        
        childLayers.forEach({ $0.update(frame: frame) })
    }
}
