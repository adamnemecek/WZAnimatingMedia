//
//  WZShapeGroupData.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/20.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import SwiftyJSON

class WZShapeGroupData: WZShapeData {
    
    private(set) var shapes: [WZShapeData] = []
    
    override func parseJSON(json: JSON) {
        super.parseJSON(json: json)
        
        for itemJSON in json["it"].arrayValue {
            
            guard let shape = WZShapeData.createShapeItem(json: itemJSON) else { continue }
            shapes.append(shape)
        }
    }
}
