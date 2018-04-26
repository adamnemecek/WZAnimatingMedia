//
//  WZAnimatingMediaView.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/18.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit
import SwiftyJSON
import MetalKit

class WZAnimatingMediaView: UIView {

    private var mtkView: MTKView
    var composition: WZComposition!
    
    init(frame: CGRect, jsonFile: String) {
        
        let mtkViewFrame: CGRect

        if let path = Bundle.main.path(forResource: jsonFile, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let composition = WZComposition(json: JSON(data))
            
            if composition.bounds.width == 0 || composition.bounds.height == 0 || frame.width == 0 || frame.height == 0 {
                mtkViewFrame = .zero
            } else {
                let widthScale = composition.bounds.width / frame.width
                let heightScale = composition.bounds.height / frame.height
                let scale = min(widthScale, heightScale)
                let mtkViewWidth = composition.bounds.width / scale
                let mtkViewHeight = composition.bounds.height / scale
                mtkViewFrame = CGRect(x: (frame.width - mtkViewWidth) / 2, y: (frame.height - mtkViewHeight) / 2, width: mtkViewWidth, height: mtkViewHeight)
            }
            
            self.composition = composition
        } else {
            self.composition = WZComposition()
            mtkViewFrame = .zero
        }
        
        self.mtkView = MTKView(frame: mtkViewFrame, device: WZRenderer.shared.device)
        self.mtkView.delegate = WZRenderer.shared
        self.mtkView.isPaused = false
        super.init(frame: frame)
        
        addSubview(mtkView)
        setupRenderData()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupRenderData() {
        
        let renderData = WZCompositionRenderData(layer: nil, layerGroup: composition.layerGroup)
        WZRenderer.shared.renderData = renderData
    }
}
