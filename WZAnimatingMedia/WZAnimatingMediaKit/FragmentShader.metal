//
//  FragmentShader.metal
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

#include <metal_stdlib>
#include "BaseInfo.metal"
using namespace metal;

fragment half4 fragment_shader(VertexToFragmentInfo fragmentIn [[stage_in]]) {
    
    return half4(1, 0, 0, 1);
}
