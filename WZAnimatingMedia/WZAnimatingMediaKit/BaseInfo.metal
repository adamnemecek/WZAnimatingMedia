//
//  BaseInfo.metal
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    packed_float2 position;
};

struct VertexToFragmentInfo {
    float4 position [[position]];
};
