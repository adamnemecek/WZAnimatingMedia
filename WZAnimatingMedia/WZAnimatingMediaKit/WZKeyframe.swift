//
//  WZKeyframe.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZKeyframe {
    
    var time = 0
    var floatValue: CGFloat = 0
    var pointValue: CGPoint = .zero
    var sizeValue: CGSize = .zero
    
    init(json: JSON) {
        parseJSON(json)
    }
    
    private func parseJSON(_ json: JSON) {
        
        time = json["t"].intValue
        
        setupKeyframeData(json["s"])
    }
    
    private func setupKeyframeData(_ json: JSON) {
        
        floatValue = CGFloat(json.floatValue)
        
        if let arrayValue = json.array {
            
            if arrayValue.count >= 1 {
                floatValue = CGFloat(arrayValue[0].floatValue)
            }
            
            if arrayValue.count == 2 {
                
                pointValue = CGPoint(x:  CGFloat(arrayValue[0].floatValue), y:  CGFloat(arrayValue[1].floatValue))
                sizeValue = CGSize(width:  CGFloat(arrayValue[0].floatValue), height:  CGFloat(arrayValue[1].floatValue))

            }
        }
    }
}
