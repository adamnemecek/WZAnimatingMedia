//
//  ViewController.swift
//  WZAnimatingMedia
//
//  Created by fanyinan on 2018/4/18.
//  Copyright © 2018年 fanyinan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = WZAnimatingMediaView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.width / 4 * 3), jsonFile: "t1")
        v.backgroundColor = .blue
        view.addSubview(v)
        
        let sl = CAShapeLayer()
        let b = UIBezierPath()
        b.move(to: CGPoint(x: -600, y: 100))
        b.addCurve(to: CGPoint(x: -200, y: 10), controlPoint1: CGPoint(x: -100, y: 0), controlPoint2: CGPoint(x: -50, y: 20))
        b.addCurve(to: CGPoint(x: -140, y: 110), controlPoint1: CGPoint(x: -150, y: 50), controlPoint2: CGPoint(x: -150, y: 90))
        b.close()
        sl.path = b.cgPath
        sl.strokeColor = UIColor.red.cgColor
        sl.lineWidth = 10
        view.layer.addSublayer(sl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

