//
//  StorageManager.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import Foundation

class StorageManager {
    private struct StorageKey {
        static let sleepTime = "sleep_hour"
        static let wakeupTime = "sleep_minute"
        static let runsCount = "runs_count"
    }
    
    static var shared: StorageManager = {
        let manager = StorageManager()
        
        return manager
    }()
    
    // get sleep time
    func getSleepTime() -> Time? {
        return UserDefaults.standard
            .object(forKey: StorageKey.sleepTime) as! Time?
    }
    
    // get wakeup time
    func getWakeUpTime() -> Time? {
        return UserDefaults.standard
            .object(forKey: StorageKey.wakeupTime) as! Time?
    }
    
    // get app runs count
    func getRunsCount() -> Int {
        return UserDefaults.standard
            .integer(forKey: StorageKey.runsCount)
    }
    
    // set sleep time
    func setTimes(sleep: Time, wakeup: Time) {
        let encoder = JSONEncoder()
        
        do {
            let sleepJson = try encoder.encode(sleep)
            let wakeupJson = try encoder.encode(wakeup)
            
            UserDefaults.standard
                .set(sleepJson, forKey: StorageKey.sleepTime)
            UserDefaults.standard
                .set(wakeupJson, forKey: StorageKey.wakeupTime)
        } catch {
            fatalError("StorageManager setTimes catch exception")
        }
    }
    
    // increase runs counter
    func increaseRunsCount() {
        UserDefaults.standard
            .set(getRunsCount() + 1, forKey: StorageKey.runsCount)
    }
}
