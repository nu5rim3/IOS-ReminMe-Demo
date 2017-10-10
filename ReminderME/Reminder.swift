//
//  Reminder.swift
//  ReminderME
//
//  Created by Nusri Samath on 10/6/17.
//  Copyright © 2017 Nusri Samath. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications


    //MARK:creating subclasses
class Reminder: NSObject,NSCoding {
    
    //MARK:properties
    
    var notification: UNMutableNotificationContent
    var name: String
    var time: NSDate
    
    //MARK:Archive for reminde saving

    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("meals")
    
    //MARK: property keys
    struct PropertyKey {
        static let nameKey = "name"
        static let timeKey = "time"
        static let notificationKey = "notification"
    }
    
    //MARK: Initilizer
    init( name:String,time:NSDate,notification:UNMutableNotificationContent) {
        self.name = name
        self.time = time
        self.notification = notification
        
        //confirm the NSobject
        super.init()
    }
    
    //destructor if user delete notification
    deinit {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // NSCoding protocol
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.nameKey)
        coder.encode(time, forKey: PropertyKey.timeKey)
        coder.encode(notification, forKey: PropertyKey.notificationKey)
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let time = aDecoder.decodeObject(forKey: PropertyKey.timeKey) as! NSDate
        
        let notification = aDecoder.decodeObject(forKey: PropertyKey.notificationKey) as! UNMutableNotificationContent
        
        // Must call designated initializer.
        self.init(name: name, time: time, notification: notification)
    }
    
    
}
