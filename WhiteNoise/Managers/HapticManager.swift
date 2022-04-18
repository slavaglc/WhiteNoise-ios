//
//  HapticManager.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 18.04.2022.
//

import UIKit

class HapticManager {
    static var shared: HapticManager = {
        let manager = HapticManager()
        
        return manager
    }()
    
    func notify(notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(notificationType)
    }
}
