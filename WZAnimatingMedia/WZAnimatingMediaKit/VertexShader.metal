//
//  VertexShader.metal
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

#include <metal_stdlib>
#include "BaseInfo.metal"
using namespace metal;


vertex VertexToFragmentInfo vertex_shader(uint vertexID [[vertex_id]],
                                constant VertexIn* vertices [[buffer(0)]]) {
    
    VertexToFragmentInfo vertexToFragmentInfo;
    
    float2 position = vertices[vertexID].position;
    
    vertexToFragmentInfo.position = float4(position, 0, 1);
    
    return vertexToFragmentInfo;
}
