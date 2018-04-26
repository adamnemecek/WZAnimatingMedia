//
//  WZRender.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import MetalKit

extension Array {
    var size: Int {
        return MemoryLayout<Element>.size * count
    }
}

struct Vertex {
    var position: (x: Float, y: Float)
}

class WZRenderer: NSObject {
    
    static var shared = WZRenderer()
    
    private(set) var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var library: MTLLibrary
    var renderData: WZCompositionRenderData!
    
    private override init() {
        
        device = MTLCreateSystemDefaultDevice()!
        commandQueue = device.makeCommandQueue()!
        library = device.makeDefaultLibrary()!

    }
    
    var i = 0
    
    func createPipelineDescriptor(vertexShaderName: String, fragmentShaderName: String) -> MTLRenderPipelineState? {
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = library.makeFunction(name: vertexShaderName)
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: fragmentShaderName)
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        let pipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        return pipelineState
    }
    
    private func createPassDescriptor() -> MTLRenderPassDescriptor {
        
        let passDescriptor = MTLRenderPassDescriptor()
        passDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        return passDescriptor
    }
}

extension WZRenderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        
        for layer in renderData.childLayers {
            
            layer.renderGroup.rootNode?.update(frame: 0)
        
        }
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            print("create commandBuffer error")
            return
        }
        
        guard let passDescriptor = view.currentRenderPassDescriptor else { return }
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor) else {
            print("create commandEncoder error")
            return
        }
        
        renderLayer(layer: renderData.wrapperLayer, commandEncoder: commandEncoder)
        
        commandEncoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
        
    }
    
    private func renderLayer(layer: WZLayer, commandEncoder: MTLRenderCommandEncoder) {
        
        layer.render(commandEncoder: commandEncoder)
        
        for subLayer in layer.sublayers {
            renderLayer(layer: subLayer, commandEncoder: commandEncoder)
        }
    }
}
