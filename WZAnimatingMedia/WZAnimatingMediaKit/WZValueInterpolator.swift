//
//  WZValueInterpolator.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit

enum WZProgressType {

    case endpoint(keyframe: WZKeyframe?)
    case middle(progress: CGFloat, leadingKeyframe: WZKeyframe, trailingKeyframe: WZKeyframe)
}

class WZValueInterpolator {
    
    private(set) var keyframes: [WZKeyframe]
    private(set) var leadingKeyframe: WZKeyframe?
    private(set) var trailingKeyframe: WZKeyframe?
    
    init(keyframes: [WZKeyframe]) {
        self.keyframes = keyframes
    }
    
    func calculateProgress(at frame: Double) -> WZProgressType {
        updateKeyframeSpan(at: frame)
        
        // Frame is after end of keyframe timeline
        guard let trailingKeyframe = trailingKeyframe else { return .endpoint(keyframe: leadingKeyframe) }

        // Frame is before start of keyframe timeline
        guard let leadingKeyframe = leadingKeyframe else { return .endpoint(keyframe: trailingKeyframe) }
        
        if Double(leadingKeyframe.time) == frame { return .endpoint(keyframe: leadingKeyframe) }
        
        if trailingKeyframe.isHold { return .endpoint(keyframe: leadingKeyframe) }
        
        let progress = WZMathTool.remapValue(value: CGFloat(frame), low1: CGFloat(leadingKeyframe.time), high1: CGFloat(trailingKeyframe.time), low2: 0, high2: 1)
        
        return .middle(progress: progress, leadingKeyframe: leadingKeyframe, trailingKeyframe: trailingKeyframe)
    }
    
    private func updateKeyframeSpan(at frame: Double) {
        
        guard !keyframes.isEmpty else { return }
        
        if leadingKeyframe == nil && trailingKeyframe == nil {
            
            let firstKeyframe = keyframes.first!
            
            if firstKeyframe.time > 0 {
                trailingKeyframe = firstKeyframe
            } else {
                leadingKeyframe = firstKeyframe
                if keyframes.count > 1 {
                    trailingKeyframe = keyframes[1]
                }
            }
        }
    }
}
