//
//  WZLayerData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WZLayerType: Int {

    case precomp
    case solid
    case image
    case null
    case shape
    case unknow
}

class WZLayerData {
    
    private var name = ""
    private var bounds: CGRect = .zero
    private var id = 0
    private var type: WZLayerType = .unknow
    private var refID: Int?
    private var parentID = 0
    private var startFrame: Int?
    private var inFrame = 0
    private var outFrame = 0
    private var timeStretch = 1
    private var opacity: WZKeyframeGroup!
    private var rotation: WZKeyframeGroup!
    private var positionX: WZKeyframeGroup!
    private var positionY: WZKeyframeGroup!
    private var position: WZKeyframeGroup!
    private var anchor: WZKeyframeGroup!
    private var scale: WZKeyframeGroup!
    private var matteType = 0
    private var shapes: [WZShapeData]!
    
    init(json: JSON) {
        
        parseJSON(json: json)
    }
    
    func parseJSON(json: JSON) {
        
        name = json["nm"].stringValue
        id = json["ind"].intValue
        type = WZLayerType(rawValue: json["ty"].intValue) ?? .unknow
        refID = json["refId"].int
        parentID = json["parent"].intValue
        startFrame = json["st"].int
        inFrame = json["ip"].intValue
        outFrame = json["op"].intValue
        timeStretch = json["sr"].int ?? 1
        
        //TODO
        var width: Float = 0
        var height: Float = 0
        
        switch type {
        case .precomp:
            break
        default:
            break
        }
        
        bounds = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        
        let keys = json["ks"]
        let opacityJSON = keys["o"]
        
        if opacityJSON.exists() {
            opacity = WZKeyframeGroup(json: opacityJSON)
            opacity.remapKeyframe { (inValue) -> CGFloat in
                return WZMathTool.remapValue(value: inValue, low1: 0, high1: 100, low2: 0, high2: 1)
            }
        }
        
        let rotationJSON = keys["r"]
        
        if rotationJSON.exists() {
            rotation = WZKeyframeGroup(json: rotationJSON)
            rotation.remapKeyframe { (inValue) -> CGFloat in
                return WZMathTool.degreesToRadians(degress: inValue)
            }
        }
        
        let positionJSON = keys["p"]
        
        if positionJSON["s"].boolValue {
            positionX = WZKeyframeGroup(json: positionJSON["x"])
            positionY = WZKeyframeGroup(json: positionJSON["y"])
        } else {
            position = WZKeyframeGroup(json: positionJSON)
        }
        
        
        if keys["a"].exists() {
            anchor = WZKeyframeGroup(json: keys["a"])
        }
        
        if keys["s"].exists() {
            scale = WZKeyframeGroup(json: keys["s"])
            scale.remapKeyframe { (inValue) -> CGFloat in
                return WZMathTool.remapValue(value: inValue, low1: -100, high1: 100, low2: -1, high2: 1)
            }
        }
        
        matteType = json["tt"].intValue
        
        for shapeJSON in json["shapes"].arrayValue {
            guard let shape = WZShapeData.createShapeItem(json: shapeJSON) else { continue }
            shapes.append(shape)
        }
    }
}
