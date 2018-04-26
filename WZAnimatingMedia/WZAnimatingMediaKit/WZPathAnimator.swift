//
//  WZPathAnimator.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/25.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation

class WZPathAnimator: WZAnimationNode {
    
    private var shapePathData: WZShapePathData
    private var pathInterpolator: WZPathInterpolator
    
    init(inputNode: WZAnimationNode?, shapePathData: WZShapePathData) {
        self.shapePathData = shapePathData
        self.pathInterpolator = WZPathInterpolator(keyframes: shapePathData.shapePath.keyframes)
        super.init(inputNode: inputNode, keyName: shapePathData.name)
    }

    override func performUpdate() {
        localPath = pathInterpolator.path(at: currentFrame)
    }
 
}
