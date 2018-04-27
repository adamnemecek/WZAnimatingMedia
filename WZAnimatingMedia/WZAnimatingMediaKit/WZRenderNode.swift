//
//  WZRenderNode.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation

class WZRenderNode: WZAnimationNode {
    
    private(set) var outputLayer: WZLayer!
    
    override var outputPath: WZBezierPath? {
        get{
            return inputNode?.outputPath
        }
        
        set{
            inputNode?.outputPath = newValue
        }
    }
    
    override var localPath: WZBezierPath? {
        get{
            return inputNode?.localPath
        }
        
        set{
            inputNode?.localPath = newValue
        }
    }
    
    override init(inputNode: WZAnimationNode?, keyName: String) {
        super.init(inputNode: inputNode, keyName: keyName)
        
        outputLayer = WZLayer()
    }
    
    
}
