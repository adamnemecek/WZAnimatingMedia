//
//  WZAnimatingMediaView.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/18.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit
import SwiftyJSON
import MetalKit

class WZAnimatingMediaView: MTKView {

    var composition: WZComposition!
    
    init(frame: CGRect, jsonFile: String) {
        
        super.init(frame: frame, device: WZRenderer.shared.device)
        delegate = WZRenderer.shared
        
        if let path = Bundle.main.path(forResource: jsonFile, ofType: "json") {
            
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                
                self.composition = WZComposition(json: JSON(data))
            }
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
