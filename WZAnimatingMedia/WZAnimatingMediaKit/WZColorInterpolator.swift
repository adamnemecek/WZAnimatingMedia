//
//  WZColorInterpolator.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit

class WZColorInterpolator: WZValueInterpolator {
    
    func color(at frame: Int) -> UIColor {
        return keyframes.first!.colorValue
    }
}
