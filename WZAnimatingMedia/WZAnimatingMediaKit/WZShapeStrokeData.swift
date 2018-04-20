//
//  WZShapeStrokeData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/20.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZShapeStrokeData: WZShapeData {
    
    private var color: WZKeyframeGroup!
    private var width: WZKeyframeGroup!
    private var opacity: WZKeyframeGroup!
    private var capType = 0
    private var joinType = 0
    private var fillEnabled = false
    
    override func parseJSON(json: JSON) {
        super.parseJSON(json: json)
        
        let colorJSON = json["c"]
        if colorJSON.exists() {
            color = WZKeyframeGroup(json: colorJSON)
        }
        
        let widthJSON = json["w"]
        if widthJSON.exists() {
            width = WZKeyframeGroup(json: widthJSON)
        }
        
        let opacityJSON = json["o"]
        if opacityJSON.exists() {
            opacity = WZKeyframeGroup(json: opacityJSON)
            opacity.remapKeyframe { (inValue) -> CGFloat in
                return WZMathTool.remapValue(value: inValue, low1: 0, high1: 100, low2: 0, high2: 1)
            }
        }
        
        capType = json["lc"].intValue - 1
        joinType = json["lj"].intValue - 1
        fillEnabled = json["fillEnabled"].boolValue
        
    }
}
