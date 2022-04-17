//
//  StorageManager.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import Foundation

class StorageManager {
    enum StorageKey: String {
        case SLEEPTIME = "sleep_hour"
        case WAKEUPTIME = "sleep_minute"
    }
    
    static var shared: StorageManager = {
        let manager = StorageManager()
        
        return manager
    }()
    
    private let defaults = UserDefaults.standard
    
    // get sleep time
    func getSleepTime() -> Time? {
        return defaults.object(forKey: StorageKey.SLEEPTIME.rawValue) as! Time?
    }
    
    // get wakeup time
    func getWakeUpTime() -> Time? {
        return defaults.object(forKey: StorageKey.WAKEUPTIME.rawValue) as! Time?
    }
    
    // set sleep time
    func setTimes(sleep: Time, wakeup: Time) {
        defaults.set(sleep, forKey: StorageKey.SLEEPTIME.rawValue)
        defaults.set(wakeup, forKey: StorageKey.WAKEUPTIME.rawValue)
    }
}
