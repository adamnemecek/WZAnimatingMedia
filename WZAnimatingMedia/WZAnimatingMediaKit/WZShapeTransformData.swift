//
//  WZShapeTransformData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/20.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZShapeTransformData: WZShapeData {
    
    private(set) var position: WZKeyframeGroup!
    private(set) var anchor: WZKeyframeGroup!
    private(set) var scale: WZKeyframeGroup!
    private(set) var rotation: WZKeyframeGroup!
    private(set) var opacity: WZKeyframeGroup!

    override func parseJSON(json: JSON) {
        super.parseJSON(json: json)
        
        let positionJSON = json["p"]
        if positionJSON.exists() {
            position = WZKeyframeGroup(json: positionJSON)
        }
        
        if json["a"].exists() {
            anchor = WZKeyframeGroup(json: json["a"])
        }
        
        if json["s"].exists() {
            scale = WZKeyframeGroup(json: json["s"])
            scale.remapKeyframe { (inValue) -> CGFloat in
                return WZMathTool.remapValue(value: inValue, low1: -100, high1: 100, low2: -1, high2: 1)
            }
        }
        
        let rotationJSON = json["r"]
        
        if rotationJSON.exists() {
            rotation = WZKeyframeGroup(json: rotationJSON)
            rotation.remapKeyframe { (inValue) -> CGFloat in
                return WZMathTool.degreesToRadians(degress: inValue)
            }
        }
        
        let opacityJSON = json["o"]
        if opacityJSON.exists() {
            opacity = WZKeyframeGroup(json: opacityJSON)
            opacity.remapKeyframe { (inValue) -> CGFloat in
                return WZMathTool.remapValue(value: inValue, low1: 0, high1: 100, low2: 0, high2: 1)
            }
        }
    }
}
