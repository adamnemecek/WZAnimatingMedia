//
//  WZShapeRectangleData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/20.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZShapeRectangleData: WZShapeData {
    
    private(set) var position: WZKeyframeGroup!
    private(set) var cornerRadius: WZKeyframeGroup!
    private(set) var size: WZKeyframeGroup!
    private(set) var reversed = false
    
    override func parseJSON(json: JSON) {
        super.parseJSON(json: json)
        
        let positionJSON = json["p"]
        if positionJSON.exists() {
            position = WZKeyframeGroup(json: positionJSON)
        }
        
        let cornerRadiusJSON = json["r"]
        if cornerRadiusJSON.exists() {
            cornerRadius = WZKeyframeGroup(json: cornerRadiusJSON)
        }
        
        let sizeJSON = json["s"]
        if sizeJSON.exists() {
            size = WZKeyframeGroup(json: sizeJSON)
        }
        
        reversed = json["d"].intValue == 3
    }
}
