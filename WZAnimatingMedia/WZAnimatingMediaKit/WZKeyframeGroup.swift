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
        
        if json["k"].exists() {
            parseJSON(json["k"])
        } else {
            parseJSON(json)
        }
    }
    
    func remapKeyframe(remapBlock: (CGFloat) -> CGFloat) {
        
        keyframes.forEach({ $0.remapValue(remapBlock: remapBlock)})
    }
    
    private func parseJSON(_ json: JSON) {
        
        if let array = json.array, let firstKey = array.first, firstKey["t"].exists() {

            var previousFrame: JSON?

            for keyframe in array {
                
                var currentFrame: JSON = [:]
                
                currentFrame["t"] = keyframe["t"]
                
                if keyframe["s"].exists() {
                    currentFrame["s"] = keyframe["s"]
                } else if let previousFrame = previousFrame, previousFrame["e"].exists() {
                    currentFrame["s"] = previousFrame["e"]
                }
                
                currentFrame["o"] = keyframe["o"]
                currentFrame["to"] = keyframe["to"]
                currentFrame["h"] = keyframe["h"]
                
                if let previousFrame = previousFrame {
                    currentFrame["i"] = previousFrame["i"]
                    currentFrame["ti"] = previousFrame["ti"]
                }
                
                let keyframe = WZKeyframe(tangentJSON: currentFrame)
                keyframes.append(keyframe)
                previousFrame = currentFrame
            }
        } else {
            
            let keyframe = WZKeyframe(value: json)
            keyframes = [keyframe]
        }
        
    }
}
