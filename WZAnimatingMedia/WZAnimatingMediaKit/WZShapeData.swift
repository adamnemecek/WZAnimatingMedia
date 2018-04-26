//
//  WZShapeData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/20.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZShapeData {
    
    private(set) var name = ""
    
    init(json: JSON) {
        parseJSON(json: json)
    }
    
    func parseJSON(json: JSON) {
        name = json["nm"].stringValue
    }
    
    class func createShapeItem(json: JSON) -> WZShapeData? {
        
        let type = json["ty"].stringValue
        
        switch type {
        case "gr":
            return WZShapeGroupData(json: json)
        case "st":
            return WZShapeStrokeData(json: json)
        case "fl":
            return WZShapeFillData(json: json)
        case "tr":
            return WZShapeTransformData(json: json)
        case "sh":
            return WZShapePathData(json: json)
        case "rc":
            return WZShapeRectangleData(json: json)
        default:
            return nil
        }
    }
}
