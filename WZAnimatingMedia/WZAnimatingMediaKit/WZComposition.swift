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
    private(set) var startFrame = 0
    private(set) var endFrame = 0
    private(set) var frameRate = 0
    private(set) var timeDuration: TimeInterval = 0
    private(set) var layerGroup: WZLayerGroupData!
    private(set) var frameCount = 0
    
    init(json: JSON) {
        parseJSON(json)
    }
    
    init() {
        layerGroup = WZLayerGroupData(layersJSON: [])
        bounds = .zero
    }
    
    private func parseJSON(_ json: JSON) {
        
        let height = json["h"].intValue
        let width = json["w"].intValue
        bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        startFrame = json["ip"].intValue
        endFrame = json["op"].intValue
        frameRate = json["fr"].intValue
        frameCount = endFrame - startFrame - 1
        
        if frameRate != 0 {
            timeDuration = TimeInterval(frameCount) / TimeInterval(frameRate)
        }
        
        layerGroup = WZLayerGroupData(layersJSON: json["layers"].arrayValue)
        
    }
}
