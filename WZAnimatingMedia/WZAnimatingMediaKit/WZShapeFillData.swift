//
//  WZShapeFillData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/20.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZShapeFillData: WZShapeData {
 
    private var color: WZKeyframeGroup!
    private var opacity: WZKeyframeGroup!
    private var evenOddFillRule = false
    private var fillEnabled = false

    override func parseJSON(json: JSON) {
        super.parseJSON(json: json)
        
        let colorJSON = json["c"]
        if colorJSON.exists() {
            color = WZKeyframeGroup(json: colorJSON)
        }
        
        let opacityJSON = json["o"]
        if opacityJSON.exists() {
            opacity = WZKeyframeGroup(json: opacityJSON)
            opacity.remapKeyframe { (inValue) -> CGFloat in
                return WZMathTool.remapValue(value: inValue, low1: 0, high1: 100, low2: 0, high2: 1)
            }
        }
        
        evenOddFillRule = json["r"].intValue == 2
        fillEnabled = json["fillEnabled"].boolValue

    }
}
