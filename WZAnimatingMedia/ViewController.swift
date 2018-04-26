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
        
        let v = WZAnimatingMediaView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.width / 4 * 3), jsonFile: "t3")
        v.backgroundColor = .blue
        view.addSubview(v)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

