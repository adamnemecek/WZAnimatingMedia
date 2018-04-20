//
//  WZTransoform.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZTransoform {
    
    private var position: WZKeyframeGroup!
    
    init(json: JSON) {
        parseJSON(json)
    }
    
    private func parseJSON(_ json: JSON) {
        
        position = WZKeyframeGroup(json: json["po"])
    }
}
