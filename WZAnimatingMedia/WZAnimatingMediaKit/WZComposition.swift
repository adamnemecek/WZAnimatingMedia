//
//  WZComposition.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation
import SwiftyJSON

class WZComposition {
    
    private(set) var bounds: CGRect!
    private var layerData: WZLayerData!
    private var startFrame = 0
    private var endFrame = 0
    private var frameRate = 0
    private var timeDuration: TimeInterval = 0
    private var layerGroup: WZLayerGroupData!
    
    init(json: JSON) {
        parseJSON(json)
    }
    
    private func parseJSON(_ json: JSON) {
        
        let height = json["h"].intValue
        let width = json["w"].intValue
        bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        startFrame = json["ip"].intValue
        endFrame = json["op"].intValue
        frameRate = json["fr"].intValue
        
        if frameRate != 0 {
            timeDuration = TimeInterval((endFrame - startFrame - 1) / frameRate)
        }
        
        layerGroup = WZLayerGroupData(layersJSON: json["layers"].arrayValue)
        
    }
}
