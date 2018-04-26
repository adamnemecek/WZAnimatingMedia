//
//  WZAnimationNode.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation

class WZAnimationNode {
    
    private(set) var keyname: String
    private(set) var inputNode: WZAnimationNode?
    private(set) var currentFrame = 0
    
    var localPath = WZBezierPath()
    
    init(inputNode: WZAnimationNode?, keyName: String) {
        self.inputNode = inputNode
        self.keyname = keyName
    }
    
    //TODO 现在在rendergroup中把最后一个当做链表的头，更新的时候相当于反向遍历，然后遍历的时候再遍历到最后一个开始向前递归调用。相当于反过来又返回去，待优化成两次都是正向，便于理解
    func update(frame: Int) {
        
        inputNode?.update(frame: frame)
        
        currentFrame = frame
        
        performUpdate()
    }
    
    func performUpdate() {
        
    }
}
