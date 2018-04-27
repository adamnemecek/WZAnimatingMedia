//
//  MatrixTool.swift
//  WZAnimatingMedia
//
//  Created by fanyinan2 on 2018/4/27.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import Foundation
import simd

extension matrix_float4x4  {
    
    static func ortho(left: Float, right: Float, bottom: Float, top: Float, nearZ: Float, farZ: Float) -> matrix_float4x4 {
        
        let ral = right + left
        let rsl = right - left
        let tab = top + bottom
        let tsb = top - bottom
        let fan = farZ + nearZ
        let fsn = farZ - nearZ
        
        let matrix = matrix_float4x4([float4(x: 2 / rsl, y: 0, z: 0, w: 0),
                         float4(x: 0, y: 2 / tsb, z: 0, w: 0),
                         float4(x: 0, y: 0, z: -2 / fsn, w: 0),
                         float4(x: -ral / rsl, y: -tab / tsb, z: -fan / fsn, w: 1)])
        
        return matrix
    }
}
