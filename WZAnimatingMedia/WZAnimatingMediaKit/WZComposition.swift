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
    
    init(json: JSON) {
        parseJSON(json)
    }
    
    private func parseJSON(_ json: JSON) {
        
        let height = json["h"].intValue
        let width = json["w"].intValue
        bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        layerData = WZLayerData(json: json["l"])
    }
}
