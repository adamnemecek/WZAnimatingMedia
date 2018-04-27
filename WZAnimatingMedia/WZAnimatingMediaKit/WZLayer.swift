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
    private var colorBuffer: MTLBuffer!
    
    var sublayers: [WZLayer] = []
    var fillColor: UIColor?
    var lineJoin: WZLineJoin = .bevel
    var fillRule = ""
    var strokeColor: UIColor?
    var lineWidth: CGFloat = 0
    var opacity: CGFloat = 0
    var path: WZBezierPath!
    
    init() {
        
        vertexIndiceBuffer = WZRenderer.shared.device.makeBuffer(length: MemoryLayout<UInt16>.size * Int(UInt16.max), options: .storageModeShared)
        verticesBuffer = WZRenderer.shared.device.makeBuffer(length: MemoryLayout<Vertex>.size * Int(UInt16.max), options: .storageModeShared)
        colorBuffer = WZRenderer.shared.device.makeBuffer(length: MemoryLayout<(Float, Float, Float)>.size, options: .storageModeShared)
    }
    
    func insert(_ sublayer: WZLayer, at index: Int) {
        sublayers.insert(sublayer, at: index)
    }
    
    func add(_ sublayer: WZLayer) {
        sublayers.append(sublayer)
    }
    
    static var w = 0
    
    func render(commandEncoder: MTLRenderCommandEncoder) {
        
        guard let path = path else { return }

        if let fillColor = fillColor {
            fill(path: path, fillColor: fillColor, commandEncoder: commandEncoder)
        }
    
        if let strokeColor = strokeColor, lineWidth > 0 {
            strok(path: path, lineWidth: lineWidth, strockColor: strokeColor, commandEncoder: commandEncoder)
        }
    }
    
    private func fill(path: WZBezierPath, fillColor: UIColor, commandEncoder: MTLRenderCommandEncoder) {
        
        var header = path.headSubPath
        var points: [CGPoint] = []

        while let subPath = header, let nextPath = subPath.nextSubPath {
            
            for i in 0..<nextPath.subdivisionSegmentsCount {
                
                let percent = CGFloat(i) / CGFloat(nextPath.subdivisionSegmentsCount)
                
                guard let subSegmentPoint = subPath.calculateValue(at: percent) else { continue }
                points.append(subSegmentPoint)
                
                
            }
            
            header = nextPath
        }
        
        let triangles = splitPolygon(vertices: points.reversed())
        var vertices = triangles.map({ Vertex(position: (x: Float($0.x), y: Float($0.y))) })
        
        let minX = vertices.min(by: {$0.position.x < $1.position.x})?.position.x ?? 0
        let minY = vertices.min(by: {$0.position.y < $1.position.y})?.position.y ?? 0
        
        vertices = vertices.map({ Vertex(position: (x: ($0.position.x - -850) / 500, y: ($0.position.y - -50) / 281))})
        vertices = vertices.map({ Vertex(position: (x: ($0.position.x * 2 - 1) / 2, y: ($0.position.y * 2 - 1) / 2))})
        vertices = vertices.map({ Vertex(position: (x: $0.position.x, y: -$0.position.y))})
        
        let ptr = verticesBuffer.contents().bindMemory(to: Vertex.self, capacity: vertices.count)
        ptr.assign(from: vertices, count: vertices.count)
        
        let ptr2 = colorBuffer.contents().bindMemory(to: (Float, Float, Float).self, capacity: 1)
        
        let components = (fillColor.cgColor.components ?? [CGFloat](repeating: 0, count: 4)).map({ Float($0) })
        ptr2.pointee = (components[0], components[1], components[2])
        
        guard let pipelineDescriptor = WZRenderer.shared.createPipelineDescriptor(vertexShaderName: "vertex_shader", fragmentShaderName: "fragment_shader") else {
            print("create pipelineDescriptor error")
            return
        }
        
        commandEncoder.setRenderPipelineState(pipelineDescriptor)
        commandEncoder.setVertexBuffer(verticesBuffer, offset: 0, index: 0)
        commandEncoder.setFragmentBuffer(colorBuffer, offset: 0, index: 0)
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)

    }
    
    private func splitPolygon(vertices: [CGPoint]) -> [CGPoint] {
        
        var k = 0
        var v = vertices
        var verticesCount = v.count
        var triangles: [CGPoint] = []
        
        while verticesCount > 3 {
            
            if k == verticesCount - 1 {
                
                k = 0
                verticesCount = v.count
                continue
                
            } else {
                
                let distance1 = v[k + 1] - v[k]
                let distance2 = v[(k + 2) % verticesCount] - v[k + 1]
                let triangle = [v[k], v[k + 1], v[(k + 2) % verticesCount]]
                
                if !isConcave(distance1: distance1, distance2: distance2) && isTriangleValid(triangle: triangle, vertices: v) {
                    triangles.append(contentsOf: triangle)
                    v.remove(at: k + 1)
                    verticesCount -= 1
                } else {
                    k += 1
                }
            }
        }
        
        let distance1 = v[1] - v[0]
        let distance2 = v[2] - v[1]
        
        if !isConcave(distance1: distance1, distance2: distance2) {
            triangles.append(contentsOf: [v[2], v[1], v[0]])
        }
        
        return triangles
        
    }
    
    private func isConcave(distance1: CGPoint, distance2: CGPoint) -> Bool {
    
        return crossProduct(distance1: distance1, distance2: distance2) < 0
        
    }
    
    private func crossProduct(distance1: CGPoint, distance2: CGPoint) -> CGFloat {
        return distance1.x * distance2.y - distance1.y * distance2.x
    }
    
    private func isTriangleValid(triangle: [CGPoint], vertices: [CGPoint]) -> Bool {
        
        let vk0vk1 = triangle[1] - triangle[0]
        let vk1vk2 = triangle[2] - triangle[1]
        
        for v in vertices where v != triangle[0] && v != triangle[1] &&  v != triangle[2]  {
            
            let vk0v = v - triangle[0]
            let vk1v = v - triangle[1]
            let vk2v = v - triangle[2]
            
            let sv0 = calculateArea(v1: vk0v, v2: vk1v)
            let sv1 = calculateArea(v1: vk1v, v2: vk2v)
            let sv2 = calculateArea(v1: vk0v, v2: vk2v)
            
            if calculateArea(v1: vk0vk1, v2: vk1vk2) == sv0 + sv1 + sv2 {
                return false
            }
            
        }
        
        return true
    }
    
    private func calculateArea(v1: CGPoint, v2: CGPoint) -> CGFloat {
        
        let cp = crossProduct(distance1: v1, distance2: v2)
        
        return cp / 2
    }
    
    private func strok(path: WZBezierPath, lineWidth: CGFloat, strockColor: UIColor, commandEncoder: MTLRenderCommandEncoder) {
        
        var vertices: [Vertex] = []
        
        var header = path.headSubPath
        
        var w = lineWidth
        
        while let subPath = header, let nextPath = subPath.nextSubPath {
            
            for i in 0...nextPath.subdivisionSegmentsCount {
                
                let percent = CGFloat(i) / CGFloat(nextPath.subdivisionSegmentsCount)
//                if [2,3,4,5,6,7,8,9].contains(i) {
//
//                    WZLayer.w = (WZLayer.w + 1) % 140
//                    w = 0
//                } else {
//                    w = lineWidth
//                }
                
                guard let subSegmentPoint = subPath.calculateValue(at: percent), let normal = subPath.calculateNormal(at: percent) else { continue }
                
                let offsetForLineWidth1 = CGVector(dx: normal.dx * -(w / 2), dy: normal.dy * -(w / 2))
                vertices.append(Vertex(position: (Float(subSegmentPoint.x + offsetForLineWidth1.dx), y: Float(subSegmentPoint.y + offsetForLineWidth1.dy))))
                
                let offsetForLineWidth2 = CGVector(dx: normal.dx * (w / 2), dy: normal.dy * (w / 2))
                vertices.append(Vertex(position: (Float(subSegmentPoint.x + offsetForLineWidth2.dx), y: Float(subSegmentPoint.y + offsetForLineWidth2.dy))))
            }
            
            header = nextPath
        }
        
        let minX = vertices.min(by: {$0.position.x < $1.position.x})?.position.x ?? 0
        let minY = vertices.min(by: {$0.position.y < $1.position.y})?.position.y ?? 0
        
        vertices = vertices.map({ Vertex(position: (x: ($0.position.x - -850) / 500, y: ($0.position.y - -50) / 281))})
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
            
//            indices.append(start)
            indices.append((start + 2) % UInt16(vertices.count))
            
            indices.append(start + 1)
            indices.append((start + 2) % UInt16(vertices.count))
            
            indices.append((start + 3) % UInt16(vertices.count))
//            indices.append(start + 1)
            
            start += 2
        }
        
        //        let vertexIndices: [UInt16] = [0,1,2,0,2,3]
        let ptr1 = vertexIndiceBuffer.contents().bindMemory(to: UInt16.self, capacity: indices.count)
        ptr1.assign(from: indices, count: indices.count)
        
        let ptr2 = colorBuffer.contents().bindMemory(to: (Float, Float, Float).self, capacity: 1)
        
        let components = (strockColor.cgColor.components ?? [CGFloat](repeating: 0, count: 4)).map({ Float($0) })
        ptr2.pointee = (components[0], components[1], components[2])
        
        guard let pipelineDescriptor = WZRenderer.shared.createPipelineDescriptor(vertexShaderName: "vertex_shader", fragmentShaderName: "fragment_shader") else {
            print("create pipelineDescriptor error")
            return
        }
        
        commandEncoder.setRenderPipelineState(pipelineDescriptor)
        commandEncoder.setVertexBuffer(verticesBuffer, offset: 0, index: 0)
        commandEncoder.setFragmentBuffer(colorBuffer, offset: 0, index: 0)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: vertexIndiceBuffer, indexBufferOffset: 0)
    }
}
