//
//  WZLayer.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/19.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit

enum WZLineJoin: Int {
    case bevel
    case miter
    case round
}

class WZLayer {
    
    private var vertexIndiceBuffer: MTLBuffer!
    private var verticesBuffer: MTLBuffer!
    
    var sublayers: [WZLayer] = []
    var fillColor: Int?
    var lineJoin: WZLineJoin = .bevel
    var fillRule = ""
    var strokeColor: Int?
    var lineWidth: CGFloat = 0
    var opacity: CGFloat = 0
    var path: WZBezierPath!
    
    init() {
        
        vertexIndiceBuffer = WZRenderer.shared.device.makeBuffer(length: MemoryLayout<UInt16>.size * Int(UInt16.max), options: .storageModeShared)
        verticesBuffer = WZRenderer.shared.device.makeBuffer(length: MemoryLayout<Vertex>.size * Int(UInt16.max), options: .storageModeShared)
    }
    
    func insert(_ sublayer: WZLayer, at index: Int) {
        sublayers.insert(sublayer, at: index)
    }
    
    func add(_ sublayer: WZLayer) {
        sublayers.append(sublayer)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder) {
        
        guard let path = path else { return }

        if let fillColor = fillColor {
            fill(path: path, fillColor: fillColor, commandEncoder: commandEncoder)
        }
        
        if let strokeColor = strokeColor, lineWidth > 0 {
            strok(path: path, lineWidth: lineWidth, strockColor: strokeColor, commandEncoder: commandEncoder)
        }
    }
    
    private func fill(path: WZBezierPath, fillColor: Int, commandEncoder: MTLRenderCommandEncoder) {
        
        
    }
    
    private func strok(path: WZBezierPath, lineWidth: CGFloat, strockColor: Int, commandEncoder: MTLRenderCommandEncoder) {
        
        var vertices: [Vertex] = []
        
        var header = path.headSubPath
        
        while let subPath = header, let nextPath = subPath.nextSubPath {
            
            for i in 0..<nextPath.subdivisionSegmentsCount {
                
                let percent = CGFloat(i) / CGFloat(nextPath.subdivisionSegmentsCount)
                
                guard let subSegmentPoint = subPath.calculateValue(at: percent), let normal = subPath.calculateNormal(at: percent) else { continue }
                
                let offsetForLineWidth1 = CGVector(dx: normal.dx * -(lineWidth / 2), dy: normal.dy * -(lineWidth / 2))
                vertices.append(Vertex(position: (Float(subSegmentPoint.x + offsetForLineWidth1.dx), y: Float(subSegmentPoint.y + offsetForLineWidth1.dy))))
                
                let offsetForLineWidth2 = CGVector(dx: normal.dx * (lineWidth / 2), dy: normal.dy * (lineWidth / 2))
                vertices.append(Vertex(position: (Float(subSegmentPoint.x + offsetForLineWidth2.dx), y: Float(subSegmentPoint.y + offsetForLineWidth2.dy))))
            }
            
            header = nextPath
        }
        
        let minX = vertices.min(by: {$0.position.x < $1.position.x})?.position.x ?? 0
        let minY = vertices.min(by: {$0.position.y < $1.position.y})?.position.y ?? 0
        
        vertices = vertices.map({ Vertex(position: (x: ($0.position.x - minX) / 500, y: ($0.position.y - minY) / 281))})
        vertices = vertices.map({ Vertex(position: (x: ($0.position.x * 2 - 1) / 2, y: ($0.position.y * 2 - 1) / 2))})
        vertices = vertices.map({ Vertex(position: (x: $0.position.x, y: -$0.position.y))})
        
        //        let vertex: [Vertex] = [Vertex(position: (-0.5, 0.5)),
        //                                Vertex(position: (0.5, 0.5)),
        //                                Vertex(position: (0.5, -0.5)),
        //                                Vertex(position: (-0.5, -0.5))
        //        ]
        
        let ptr = verticesBuffer.contents().bindMemory(to: Vertex.self, capacity: vertices.count)
        ptr.assign(from: vertices, count: vertices.count)
        
        var indices: [UInt16] = []
        
        var start: UInt16 = 0
        
        for _ in 0..<UInt16(vertices.count) / 2 {
            
            indices.append(start)
            indices.append(start + 1)
            
            indices.append(start)
            indices.append((start + 2) % UInt16(vertices.count))
            
            indices.append(start + 1)
            indices.append((start + 2) % UInt16(vertices.count))
            
            indices.append((start + 3) % UInt16(vertices.count))
            indices.append(start + 1)
            
            start += 2
        }
        
        //        let vertexIndices: [UInt16] = [0,1,2,0,2,3]
        let ptr1 = vertexIndiceBuffer.contents().bindMemory(to: UInt16.self, capacity: indices.count)
        ptr1.assign(from: indices, count: indices.count)
        
        guard let pipelineDescriptor = WZRenderer.shared.createPipelineDescriptor(vertexShaderName: "vertex_shader", fragmentShaderName: "fragment_shader") else {
            print("create pipelineDescriptor error")
            return
        }
        
        commandEncoder.setRenderPipelineState(pipelineDescriptor)
        commandEncoder.setVertexBuffer(verticesBuffer, offset: 0, index: 0)
        commandEncoder.drawIndexedPrimitives(type: .line, indexCount: indices.count, indexType: .uint16, indexBuffer: vertexIndiceBuffer, indexBufferOffset: 0)
        
    }
}
