//
//  LAEController.swift
//  nervousnet-iOS
//  
//  Created by __DEVNAME__ on 03 Mar 2016.
//  Copyright (c) 2016 ETHZ . All rights reserved.
//
//WARNING - THIS CODE IS AUTOGENERATED BY DEVSKETCH AND CAN BE OVERWRITTEN


import Foundation
import CoreData
import UIKit

///
/// Takes the raw data from SensorController and “processes” it.
///
class LAEController : NSObject {

    // get the real time data
    func getData(sensor: String) -> Array<AnyObject>{
        var data = [AnyObject]()
        
        if sensor == "Accelerometer" {
            
            let sen = AccelerometerController.sharedInstance
            data.append(sen.x)
            data.append(sen.y)
            data.append(sen.z)
        }
        
        if sensor == "Gyroscope" {
            
            let sen = GyroscopeController.sharedInstance
            data.append(sen.x)
            data.append(sen.y)
            data.append(sen.z)
        }
        
        if sensor == "Magnetometer" {
            
            let sen = MagnetometerController.sharedInstance
            data.append(sen.x)
            data.append(sen.y)
            data.append(sen.z)
        }
        
        if sensor == "Battery" {
            
            let sen = BatteryController.sharedInstance
            data.append(sen.percent)
            data.append(sen.isCharging)
            data.append(sen.charging_type)
        }
        
        if sensor == "BLE" {
            
            let sen = BLEController.sharedInstance
            data.append(sen.blepacket)
            print(sen.blepacket)
        }
        
        if sensor == "GPS" {
            
            let sen = GPSController.sharedInstance
            data.append(sen.lat)
            data.append(sen.long)
        }
			
			if sensor == "Beacon" {
				let sen = BeaconController.sharedInstance
//				data = sen.beaconData
				data = sen.getdata()
			}
				
        return data
    }
    
    
    //sensor string is the name of the coredata object
    func getData(sensor: String, from: UInt64, to: UInt64) -> Array<Array<AnyObject>>{
        
        var data = [[AnyObject]]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: sensor)
        let predicate = NSPredicate(format: "(timestamp >= %@) AND (timestamp < %@)", to, from)
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            let result = try context.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                if let x = managedObject.valueForKey("x"), y = managedObject.valueForKey("y"), z = managedObject.valueForKey("z"), timestamp = managedObject.valueForKey("timestamp"){
                    var d = [AnyObject]()
                    d.append(timestamp)
                    d.append(x)
                    d.append(y)
                    d.append(z)
                    
                    data.append(d)
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return data

    }
    
    
    // gets the average of the data
    func mean(sensor: String, from: UInt64, to: UInt64) -> Array<AnyObject> {
        
        let data = getData(sensor, from: from, to: to)
        
        var mean_x : Float = 0.0
        var mean_y : Float = 0.0
        var mean_z : Float = 0.0
        
        var mean = [AnyObject]()
        
        for i in 0 ..< data.count {
                
                mean_x += Float(data[i][1] as! NSNumber)
                mean_y += Float(data[i][2] as! NSNumber)
                mean_z += Float(data[i][3] as! NSNumber)
        }
        
        mean_x /= Float(data.count)
        mean_y /= Float(data.count)
        mean_z /= Float(data.count)
        
        mean.append(mean_x)
        mean.append(mean_y)
        mean.append(mean_z)
        
        
        return mean
    }
    
    
    // get the maximum of the data
    func max(sensor: String, from: UInt64, to: UInt64, dim: String = "all") -> Array<AnyObject> {
        
        let data = getData(sensor, from: from, to: to)
        
        var max_x : Double = 0.0
        var max_y : Double = 0.0
        var max_z : Double = 0.0
        
        var max = [AnyObject]()
        
        var x : Double
        var y : Double
        var z : Double
        
        for i in 0 ..< data.count {
            
            x = Double(data[i][1] as! NSNumber)
            if x > max_x {
                max_x = x
            }
            y = Double(data[i][1] as! NSNumber)
            if y > max_y {
                max_y = y
            }
            z = Double(data[i][1] as! NSNumber)
            if z > max_z {
                max_z = z
            }
        }
        
        if dim == "all" {
            max.append(max_x)
            max.append(max_y)
            max.append(max_z)
        } else if dim == "x" {
            max.append(max_x)
        } else if dim == "y" {
            max.append(max_y)
        } else if dim == "z" {
            max.append(max_z)
        }else {
            max.append(0.0)
        }
        
        return max
    }
    
    
    // get the minimum of the data
    func min(sensor: String, from: UInt64, to: UInt64, dim: String = "all") -> Array<AnyObject> {
        
        let data = getData(sensor, from: from, to: to)
        
        var min_x : Double = 1000.0
        var min_y : Double = 1000.0
        var min_z : Double = 1000.0
        
        var min = [AnyObject]()
        
        var x : Double
        var y : Double
        var z : Double
        
        for i in 0 ..< data.count {
            
            x = Double(data[i][1] as! NSNumber)
            if x < min_x {
                min_x = x
            }
            y = Double(data[i][1] as! NSNumber)
            if y < min_y {
                min_y = y
            }
            z = Double(data[i][1] as! NSNumber)
            if z < min_z {
                min_z = z
            }
        }
        
        if dim == "all" {
            min.append(min_x)
            min.append(min_y)
            min.append(min_z)
        } else if dim == "x" {
            min.append(min_x)
        } else if dim == "y" {
            min.append(min_y)
        } else if dim == "z" {
            min.append(min_z)
        }else {
            min.append(0.0)
        }
        
        return min
    }
}