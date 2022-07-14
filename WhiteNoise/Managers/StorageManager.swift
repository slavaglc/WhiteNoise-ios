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
    
    /// get sleep time
    func getSleepTime() -> Time? {
        let decoder = JSONDecoder()
       guard let jsonObject = UserDefaults.standard
        .object(forKey: StorageKey.sleepTime) as? Data else { return nil }
        do {
        let decoded = try decoder.decode(Time.self, from: jsonObject)
            return decoded
        } catch {
           print("DECODER ERROR")
        }
        return nil
    }
    
    /// get wakeup time
    func getWakeUpTime() -> Time? {
        let decoder = JSONDecoder()
       guard let jsonObject = UserDefaults.standard
        .object(forKey: StorageKey.wakeupTime) as? Data else { return nil }
        do {
        let decoded = try decoder.decode(Time.self, from: jsonObject)
            return decoded
        } catch {
           print("DECODER ERROR")
        }
        return nil
    }
    
    /// get app runs count
    func getRunsCount() -> Int {
        return UserDefaults.standard
            .integer(forKey: StorageKey.runsCount)
    }
    
    /// set sleep time
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
    
    /// increase runs counter
    func increaseRunsCount() {
        UserDefaults.standard
            .set(getRunsCount() + 1, forKey: StorageKey.runsCount)
    }
}
