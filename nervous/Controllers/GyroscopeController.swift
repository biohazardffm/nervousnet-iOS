//
//  GyroscopeController.swift
//  nervousnet-iOS
//  
//  Created by __DEVNAME__ on 03 Mar 2016.
//  Copyright (c) 2016 ETHZ . All rights reserved.
//
//WARNING - THIS CODE IS AUTOGENERATED BY DEVSKETCH AND CAN BE OVERWRITTEN


import Foundation
import CoreMotion

class GyroscopeController : NSObject {


    private var auth: Int = 0
    
    private let manager:  CMMotionManager
    
    private let VM = VMController.sharedInstance
    
    var timestamp: UInt64 = 0
    var x: Float = 0.0
    var y: Float = 0.0
    var z: Float = 0.0
    
    override init() {
        self.manager = CMMotionManager()
    }
    
    func requestAuthorization() {
        print("requesting authorization for acc")
        
        let val1 = self.VM.defaults.objectForKey("kill") as! Bool
        let val2 = self.VM.defaults.objectForKey("switchGyr") as! Bool
        
        if val1 && val2  {
            if self.manager.gyroActive && self.manager.gyroAvailable {
                self.auth = 1
            }
        }
        else {
            self.auth = 0
        }
    }
    
    // requestAuthorization must be before this is function is called
    func startSensorUpdates(freq: Double) {
        
        if self.auth == 0 {
            return
        }
        
        self.manager.gyroUpdateInterval = freq
        self.manager.startGyroUpdates()
        let currentTimeA :NSDate = NSDate()
        
        self.timestamp = UInt64(currentTimeA.timeIntervalSince1970*1000) // time to timestamp
        if let data = self.manager.gyroData {
            self.x = Float(data.rotationRate.x)
            self.y = Float(data.rotationRate.y)
            self.z = Float(data.rotationRate.z)
        }
    }
    
    func stopSensorUpdates() {
        self.manager.stopGyroUpdates()
        self.auth = 0
    }
}