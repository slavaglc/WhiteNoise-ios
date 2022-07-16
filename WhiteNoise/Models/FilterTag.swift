//
//  FilterTag.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 21.04.2022.
//

import Foundation


struct FilterTag {
    let title: String
    
    static func getAllFilterTags() -> [FilterTag] {
        [
            FilterTag(title: "All"),
            FilterTag(title: "Water"),
            FilterTag(title: "Rain"),
            FilterTag(title: "Noise"),
            FilterTag(title: "Vehicle")
            
        ]
    }
}
