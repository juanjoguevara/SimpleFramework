//
//  ViewController.swift
//  JJMRSDK-Demo
//
//  Created by Juan José Guevara Muñoz on 9/4/18.
//  Copyright © 2018 Juan José Guevara Muñoz. All rights reserved.
//

import UIKit
import JJMRSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        JJMRSDK.shared.hello()
        JJMRSDK.shared.goodbye()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

