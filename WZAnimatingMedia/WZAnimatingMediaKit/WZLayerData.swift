//
//  WZLayerData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation
import SwiftyJSON

class WZLayerData {
    
    var transform: WZTransoform?
    var size: CGSize = .zero
    var layerDatas: [WZLayerData] = []
    
    init(json: JSON) {
        
        parseJSON(json: json)
    }
    
    func parseJSON(json: JSON) {
        
        size = CGSize(width: CGFloat(json["w"].floatValue), height: CGFloat(json["h"].floatValue))
        
        let keyframes = json["ks"]
        
        transform = WZTransoform(json: keyframes["tr"])
    }
}
