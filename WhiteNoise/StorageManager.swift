//
//  StorageManager.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import Foundation

class StorageManager {
    static var shared: StorageManager = {
        let manager = StorageManager()
        
        return manager
    }()
    
    private let defaults = UserDefaults.standard
}
