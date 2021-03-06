//
//  BatteryController.swift
//  nervousnet-iOS
//  
//  Created by __DEVNAME__ on 03 Mar 2016.
//  Copyright (c) 2016 ETHZ . All rights reserved.
//
//WARNING - THIS CODE IS AUTOGENERATED BY DEVSKETCH AND CAN BE OVERWRITTEN


import Foundation
import UIKit
import CoreData

private let _BAT = BatteryController()
class BatteryController : NSObject {
    
    private var auth: Int = 0
    
    private let VM = VMController.sharedInstance
    
    var timestamp: UInt64 = 0
    var percent: Float = 0.0
    var isCharging: Bool = false
    var charging_type: Int = 0 // 0 - unknown, 1 - USB, 2 - Ac, 3 - Wireless
    
    override init() {
        
    }
    
    class var sharedInstance: BatteryController {
        return _BAT
    }
    
    func requestAuthorization() {
        
        print("requesting authorization for battery")
        
        let val1 = self.VM.defaults.boolForKey("kill")   //objectForKey("kill") as! Bool
        let val2 = self.VM.defaults.boolForKey("switchBat")    //objectForKey("switchBat") as! Bool
        
        if !val1 && val2  {
            self.auth = 1
        }
        else {
            self.auth = 0
        }
    }
    
    func initializeUpdate() {
        
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        
    }
    
    func startSensorUpdates() {
        
        if self.auth == 0 {
            return
        }
        
        let currentTimeA :NSDate = NSDate()
        self.timestamp = UInt64(currentTimeA.timeIntervalSince1970*1000)
        
        self.percent = UIDevice.currentDevice().batteryLevel
        if UIDevice.currentDevice().batteryState.rawValue == 2 {
            self.isCharging = true
        }
        
        let val = self.VM.defaults.objectForKey("logBat") as! Bool
        if val {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let entity = NSEntityDescription.entityForName("Battery", inManagedObjectContext:
                managedContext)
            let bat = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            bat.setValue(NSNumber(unsignedLongLong: self.timestamp) , forKey: "timestamp")
            bat.setValue(self.percent, forKey: "percent")
            bat.setValue(self.isCharging, forKey: "isCharging")
            bat.setValue(self.charging_type, forKey: "charging_type")
        }
    }
    
    func stopSensorUpdates() {
        
        UIDevice.currentDevice().batteryMonitoringEnabled = false
        self.auth = 0
    }
}