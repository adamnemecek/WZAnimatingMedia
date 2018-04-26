//
//  WZLayerGroupData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/20.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZLayerGroupData {
    
    private(set) var layerDatas: [WZLayerData] = []
    private var layerMap: [Int: WZLayerData] = [:]
    
    init(layersJSON: [JSON]) {
        parseJSON(layersJSON: layersJSON)
    }
    
    private func parseJSON(layersJSON: [JSON]) {

        for layerJSON in layersJSON {
            
            let layerData = WZLayerData(json: layerJSON)
            layerDatas.append(layerData)
//            layerMap[layerData.]
        }
        
    }
}
