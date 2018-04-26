//
//  WZShapePathData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/25.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZShapePathData: WZShapeData {
    
    private var index = 0
    private(set) var shapePath: WZKeyframeGroup!
    
    override func parseJSON(json: JSON) {
        super.parseJSON(json: json)
        
        index = json["ind"].intValue
        
        let pathJSON = json["ks"]
        if pathJSON.exists() {
            shapePath = WZKeyframeGroup(json: pathJSON)
        }
    }
}
