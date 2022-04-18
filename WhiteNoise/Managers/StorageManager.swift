//
//  StorageManager.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import Foundation

class StorageManager {
    struct StorageKey {
        static let sleepTime = "sleep_hour"
        static let wakeupTime = "sleep_minute"
    }
    
    static var shared: StorageManager = {
        let manager = StorageManager()
        
        return manager
    }()
    
    private let defaults = UserDefaults.standard
    
    // get sleep time
    func getSleepTime() -> Time? {
        return defaults.object(forKey: StorageKey.sleepTime) as! Time?
    }
    
    // get wakeup time
    func getWakeUpTime() -> Time? {
        return defaults.object(forKey: StorageKey.wakeupTime) as! Time?
    }
    
    // set sleep time
    func setTimes(sleep: Time, wakeup: Time) {
        let encoder = JSONEncoder()
        
        do {
            let sleepJson = try encoder.encode(sleep)
            let wakeupJson = try encoder.encode(wakeup)
            
            defaults.set(sleepJson, forKey: StorageKey.sleepTime)
            defaults.set(wakeupJson, forKey: StorageKey.wakeupTime)
        } catch {
            fatalError("StorageManager setTimes catch exception")
        }
    }
}
