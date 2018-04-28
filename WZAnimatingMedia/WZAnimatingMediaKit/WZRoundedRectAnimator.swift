//
//  WZRoundedRectAnimator.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/23.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit

class WZRoundedRectAnimator: WZAnimationNode {
    
    private var centerInterpolator: WZPointInterpolator
    private var sizeInterpolator: WZPointInterpolator
    private var cornerRadiusInterpolator: WZNumberInterpolator
    private var reversed:Bool
    
    init(inputNode: WZAnimationNode?, shapeRectangleData: WZShapeRectangleData) {
        
        self.centerInterpolator = WZPointInterpolator(keyframes: shapeRectangleData.position.keyframes)
        self.sizeInterpolator = WZPointInterpolator(keyframes: shapeRectangleData.size.keyframes)
        self.cornerRadiusInterpolator = WZNumberInterpolator(keyframes: shapeRectangleData.cornerRadius.keyframes)
        self.reversed = shapeRectangleData.reversed
        
        super.init(inputNode: inputNode, keyName: shapeRectangleData.name)
        
    }
    
    override func performUpdate() {
        localPath = createBezierPath()
    }
    
    private func createBezierPath() -> WZBezierPath {
        
        let cornerRadius: CGFloat = 6
        let size = CGSize(width: 200, height: 100)
        let position = CGPoint(x: 0, y: 0)
        
        let halfWidth = size.width / 2
        let halfHeight = size.height / 2
        let ellipseControlPointPercentage: CGFloat = 0.55228
        
        let controlPointOffset = cornerRadius * ellipseControlPointPercentage
        
        let topLeftCorner = CGPoint(x: position.x - halfWidth, y: position.y - halfHeight)
        let topRightCorner = CGPoint(x: position.x + halfWidth, y: position.y - halfHeight)
        let bottomRightCorner = CGPoint(x: position.x + halfWidth, y: position.y + halfHeight)
        let bottomLeftCorner = CGPoint(x: position.x - halfWidth, y: position.y + halfHeight)

        let topLeft = CGPoint(x: topLeftCorner.x + cornerRadius, y: topLeftCorner.y)
        let topRight = CGPoint(x: topRightCorner.x - cornerRadius, y: topRightCorner.y)
        
        let rightTop = CGPoint(x: topRightCorner.x, y: topRightCorner.y + cornerRadius)
        let rightBottom = CGPoint(x: bottomRightCorner.x, y: bottomRightCorner.y - cornerRadius)
        
        let bottomRight = CGPoint(x: bottomRightCorner.x - cornerRadius, y: bottomRightCorner.y)
        let bottomLeft = CGPoint(x: bottomLeftCorner.x + cornerRadius, y: bottomLeftCorner.y)
        
        let leftBottom = CGPoint(x: bottomLeftCorner.x, y: bottomLeftCorner.y - cornerRadius)
        let leftTop = CGPoint(x: topLeftCorner.x, y: topLeftCorner.y + cornerRadius)
        
        let points = [topLeft, topRight, rightTop, rightBottom, bottomRight, bottomLeft, leftBottom, leftTop, topLeft]
        
        let bezierPath = WZBezierPath()
        bezierPath.move(to: points.first!)
        
        for i in 0..<points.count / 2 {
            
            let lineEndPoint = points[i * 2 + 1]
            let curveEndPoint = points[i * 2 + 2]

            bezierPath.addLine(endPoint: lineEndPoint)
            
            func x(a: CGFloat, b: CGFloat, c: CGFloat) -> CGFloat {
                
                let d = a - b
                
                if abs(d) == c {
                    return 0
                } else {
                    return CGFloat(roundf(Float(d / c)))
                }
            }
            
            let xFactor1 = x(a: position.x, b: lineEndPoint.x, c: halfWidth)
            let yFactor1 = x(a:position.y, b: lineEndPoint.y, c: halfHeight)
            let controlPoint1 = CGPoint(x: lineEndPoint.x + xFactor1 * controlPointOffset, y: lineEndPoint.y + yFactor1 * controlPointOffset)
            
            let xFactor2 = x(a: position.x, b: curveEndPoint.x, c: halfWidth)
            let yFactor2 = x(a: position.y, b: curveEndPoint.y, c: halfHeight)
            let controlPoint2 = CGPoint(x: points[i].x + xFactor2 * controlPointOffset, y: points[i].y + yFactor2 * controlPointOffset)
            
            bezierPath.addCurve(endPoint: points[i + 1], controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
        
        return bezierPath
    }
}
