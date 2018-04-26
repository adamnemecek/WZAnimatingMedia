//
//  WZBezierPath.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/25.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZBezierData {
    
    private(set) var vertices: [CGPoint] = []
    private(set) var inTangents: [CGPoint] = []
    private(set) var outTangents: [CGPoint] = []
    private(set) var closed = false
    private(set) var count = 0
    
    init() {
        
    }
    
    init(json: JSON) {
        
        let pointJSONs = json["v"].arrayValue
        let inTangentJSONs = json["i"].arrayValue
        let outTangentJSONs = json["o"].arrayValue
        
        count = pointJSONs.count
        closed = json["c"].boolValue
        
        for i in 0..<count {
            
            let vertex = point(in: pointJSONs[i].arrayValue)
            let inTangent = vertex + point(in: inTangentJSONs[i].arrayValue)
            let outTangent = vertex + point(in: outTangentJSONs[i].arrayValue)
            
            vertices.append(vertex)
            inTangents.append(inTangent)
            outTangents.append(outTangent)
        }
    }
    
    private func point(in array: [JSON]) -> CGPoint {
        
        guard array.count >= 2 else { return .zero }
        
        return CGPoint(x: CGFloat(array[0].floatValue), y: CGFloat(array[1].floatValue))
    }
}
