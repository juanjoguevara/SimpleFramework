//
//  JJMRSDK.swift
//  JJMRSDK
//
//  Created by Juan José Guevara Muñoz on 9/4/18.
//  Copyright © 2018 Juan José Guevara Muñoz. All rights reserved.
//

import UIKit

@objc open class JJMRSDK: NSObject {
    @objc public static let shared = JJMRSDK()
    
    @objc open func hello(){
        debugPrint("Hello World!")
    }
    
    @objc open func goodbye(){
        debugPrint("Goodbye World!")
    }
}
