//
//  WZBezierPath.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/25.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit

class WZSubPath {

    var endPoint: CGPoint
    var controlPoint1: CGPoint
    var controlPoint2: CGPoint
    var approxLength: CGFloat
    var nextSubPath: WZSubPath?
    var subdivisionSegmentsCount: Int
    
    private let precision: CGFloat = 50
    
    init(endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint, approxLength: CGFloat) {
        self.endPoint = endPoint
        self.controlPoint1 = controlPoint1
        self.controlPoint2 = controlPoint2
        self.approxLength = approxLength
        
        let segments = approxLength / precision
        subdivisionSegmentsCount = Int(ceilf(Float(sqrt(segments * segments * 0.6 + 255))))
    }
    
    func calculateValue(at t: CGFloat) -> CGPoint? {
        
        guard let nextSubPath = nextSubPath else { return nil }
        
        return WZMathTool.pointInCubic(startPoint: endPoint,
                                       controlPoint1: nextSubPath.controlPoint1,
                                       controlPoint2: nextSubPath.controlPoint2,
                                       endPoint: nextSubPath.endPoint,
                                       t: t)
    }
    
    func calculateNormal(at t: CGFloat) -> CGVector? {
        
        guard let nextSubPath = nextSubPath else { return nil }
        
        let a = endPoint
        let p1 = nextSubPath.controlPoint1
        let p2 = nextSubPath.controlPoint2
        let b = nextSubPath.endPoint
        
        let nt = 1.0 - t

        let dx = -3.0 * a.x * nt * nt  +  3.0 * p1.x * (1.0 - 4.0 * t + 3.0 * t * t)  +  3.0 * p2.x * (2.0 * t - 3.0 * t * t)  +  3.0 * b.x * t * t
        let dy = -3.0 * a.y * nt * nt  +  3.0 * p1.y * (1.0 - 4.0 * t + 3.0 * t * t)  +  3.0 * p2.y * (2.0 * t - 3.0 * t * t)  +  3.0 * b.y * t * t
        
        let tangent = CGVector(dx: dx, dy: dy)
        var normal = CGVector(dx: -tangent.dy, dy: tangent.dx)
        let normalLength = sqrt(normal.dx * normal.dx + normal.dy * normal.dy)
        
        if normalLength == 0 {
            return CGVector(dx: -1, dy: 0)
        }
        
        let scale = 1 / normalLength
        normal = CGVector(dx: normal.dx * scale, dy: normal.dy * scale)
        
        return normal
    }
}

class WZBezierPath {
    
    private var startPoint: CGPoint = .zero
    private(set) var headSubPath: WZSubPath?
    private var tailSubPath: WZSubPath?
    
    func move(to point: CGPoint) {
        
        startPoint = point
        addSubPath(endPoint: point, controlPoint1: .zero, controlPoint2: .zero, approxLength: 0)
    }
    
    func addLine(endPoint: CGPoint) {
        
        guard let tailSubPath = tailSubPath else { return }
        
        let length = distance(point1: tailSubPath.endPoint, point2: endPoint)
        addSubPath(endPoint: endPoint, controlPoint1: tailSubPath.endPoint, controlPoint2: endPoint, approxLength: length)
    }
    
    func addCurve(endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        
        guard let tailSubPath = tailSubPath else { return }

        var length: CGFloat = 0
        
        length += distance(point1: tailSubPath.endPoint, point2: tailSubPath.controlPoint2)
        length += distance(point1: tailSubPath.controlPoint2, point2: controlPoint1)
        length += distance(point1: controlPoint1, point2: endPoint)
        
        addSubPath(endPoint: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2, approxLength: length)
    }
    
    private func addSubPath(endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint, approxLength: CGFloat) {
        
        let subPath = WZSubPath(endPoint: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2, approxLength: approxLength)
        
        if let _tailSubPath = tailSubPath {
            
            _tailSubPath.nextSubPath = subPath
            tailSubPath = subPath
            
        } else {
            
            headSubPath = subPath
            tailSubPath = subPath
        }
    }
    
    private func distance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        return sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y))
    }
}
