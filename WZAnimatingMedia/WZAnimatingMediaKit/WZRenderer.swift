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
    var position: (x: Float, y: Float, z: Float)
}

class WZRenderer: NSObject {
    
    static var shared = WZRenderer()
    
    private(set) var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var library: MTLLibrary
    private var vertexIndiceBuffer: MTLBuffer!
    private var verticesBuffer: MTLBuffer!
    
    private override init() {
        
        device = MTLCreateSystemDefaultDevice()!
        commandQueue = device.makeCommandQueue()!
        library = device.makeDefaultLibrary()!
        
        var vertexIndices: [UInt16] = [0,1,2,0,2,3]
        vertexIndiceBuffer = device.makeBuffer(bytes: vertexIndices, length: vertexIndices.size)
        
        let vertex: [Vertex] = [Vertex(position: (-1.0, 1.0, 0)),
                                Vertex(position: (1.0, 1.0, 0)),
                                Vertex(position: (1.0, -1.0, 0)),
                                Vertex(position: (-1.0, -1.0, 0))
        ]
        
        verticesBuffer = device.makeBuffer(bytes: vertex, length: vertex.size)
    }
    
    private func createPipelineDescriptor(vertexShaderName: String, fragmentShaderName: String) -> MTLRenderPipelineState? {
        
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
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            print("create commandBuffer error")
            return
        }
        
        guard let passDescriptor = view.currentRenderPassDescriptor else { return }
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor) else {
            print("create commandEncoder error")
            return
        }
        
        guard let pipelineDescriptor = createPipelineDescriptor(vertexShaderName: "vertex_shader", fragmentShaderName: "fragment_shader") else {
            print("create pipelineDescriptor error")
            return
        }
        
        commandEncoder.setRenderPipelineState(pipelineDescriptor)
        
        commandEncoder.setVertexBuffer(verticesBuffer, offset: 0, index: 0)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: 6, indexType: .uint16, indexBuffer: vertexIndiceBuffer, indexBufferOffset: 0)
        
        commandEncoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
        
    }
}
