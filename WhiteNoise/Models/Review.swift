//
//  Review.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 23.07.2022.
//

import Foundation


struct Review {
    let name: String
    let reviewText: String
    
    static func getAllReviews() -> [Review] {
        [
            Review(name: "Elena Antonova", reviewText: "I liked the app, the sounds are high quality, can work in the background, set a timer for the duration of the white noise! In general, I recommend it for parents of kids!"),
            Review(name: "Nadya Cherniy", reviewText: "It was very helpful for me for the first three years of a child’s life. No ads. Endless playback! You can mix sounds with different volumes with each other. For me - it’s the best! And I’ve tried quite a few."),
           Review(name: "Catherine Bragina", reviewText: "Everything is clear and simple. I found the app useful. I turn on the sea noise as a background for the baby's sleep and set a timer")
        ]
    }
}
