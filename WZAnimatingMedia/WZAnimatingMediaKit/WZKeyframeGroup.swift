//
//  WZKeyframeGroup.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZKeyframeGroup {
    
    private var keyframes: [WZKeyframe] = []
    
    init(json: JSON) {
        parseJSON(json)
    }
    
    private func parseJSON(_ json: JSON) {
        
        for keyframeJSON in json["k"].arrayValue {
            
            keyframes.append(WZKeyframe(json: keyframeJSON))
        }
    }
}
