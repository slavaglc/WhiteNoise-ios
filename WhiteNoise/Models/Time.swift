//
//  Time.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import Foundation

struct Time: Codable {
    let hour: Int
    let minute: Int
    
    static func getAllMinutes() -> [Int16] {
        var minutes = [Int16]()
        (1...60).forEach { number in
            minutes.append(number)
        }
        return minutes
    }
    
    static func getAllMinutesString() -> [String] {
       let minutes = getAllMinutes()
        var minuteStrings = [String]()
        minutes.forEach { number in
            minuteStrings.append("\(number) min")
        }
        return minuteStrings
    }
}
