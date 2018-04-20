//
//  WZKeyframe.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZKeyframe {
    
    private var time = 0
    private var isHold = true
    private var inTangent: CGPoint = .zero
    private var outTangent: CGPoint = .zero
    private var spatialOutTangent: CGPoint = .zero
    private var spatialInTangent: CGPoint = .zero
    
    var floatValue: CGFloat = 0
    var pointValue: CGPoint = .zero
    var sizeValue: CGSize = .zero
    
    init(tangentJSON: JSON) {
        parseJSON(tangentJSON)
    }
    
    init(value: JSON) {
        setupOutput(value)
    }
    
    func remapValue(remapBlock: (CGFloat) -> CGFloat) {
    
        floatValue = remapBlock(floatValue)
        pointValue = CGPoint(x: remapBlock(pointValue.x), y: remapBlock(pointValue.y))
        sizeValue = CGSize(width: remapBlock(sizeValue.width), height: remapBlock(sizeValue.height))
    }
    
    private func parseJSON(_ json: JSON) {
        
        time = json["t"].intValue
        inTangent = CGPoint(x: CGFloat(json["i"]["x"].floatValue), y: CGFloat(json["i"]["y"].floatValue))
        outTangent = CGPoint(x: CGFloat(json["o"]["x"].floatValue), y: CGFloat(json["o"]["y"].floatValue))
        isHold = json["h"].boolValue
        
        if let values = json["to"].array {
            spatialOutTangent = pointFrameValueArray(values: values)
        }
        
        if let values = json["ti"].array {
            spatialInTangent = pointFrameValueArray(values: values)
        }
        
        if json["s"].exists() {
            setupOutput(json["s"])
        }
    }
    
    private func setupOutput(_ json: JSON) {
        
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
    
    private func pointFrameValueArray(values: [JSON]) -> CGPoint {
        
        var point: CGPoint = .zero
        
        if values.count >= 2 {
            point.x = CGFloat(values[0].floatValue)
            point.y = CGFloat(values[1].floatValue)
        }
        
        return point
    }
}
