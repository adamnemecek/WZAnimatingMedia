//
//  WZKeyframe.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZKeyframe {
    
    private(set) var time = 0
    private(set) var isHold = true
    
    //表示对progress进行曲线处理
    private var inTangent: CGPoint = .zero
    private var outTangent: CGPoint = .zero
    
    //表示对值本身进行曲线处理
    private(set) var spatialOutTangent: CGPoint = .zero
    private(set) var spatialInTangent: CGPoint = .zero
    
    var floatValue: CGFloat = 0
    var pointValue: CGPoint = .zero
    var sizeValue: CGSize = .zero
    var colorValue: UIColor = .white
    var beizerData = WZBezierData()
    
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
        
        if let floatValue = json.float {
            
            self.floatValue = CGFloat(floatValue)
            
        } else if let arrayValue = json.array {
            
            if arrayValue.count >= 1 {
                floatValue = CGFloat(arrayValue[0].floatValue)
            }
            
            if arrayValue.count >= 2 {
                
                pointValue = pointFrameValueArray(values: arrayValue)
                sizeValue = sizeFrameValueArray(values: arrayValue)

            }
            
            if arrayValue.count >= 4 {
                
                var colorComponents = arrayValue.map({ CGFloat($0.floatValue) })
                if colorComponents.max()! > 1 {
                    colorComponents = colorComponents.map({ $0 / CGFloat(255) })
                }
                
                colorValue = UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: colorComponents[3])
            }
            
        } else {
            
            beizerData = WZBezierData(json: json)
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
    
    private func sizeFrameValueArray(values: [JSON]) -> CGSize {
        
        var point: CGSize = .zero
        
        if values.count >= 2 {
            point.width = CGFloat(values[0].floatValue)
            point.height = CGFloat(values[1].floatValue)
        }
        
        return point
    }
}
