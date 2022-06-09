//
//  Sound.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 20.04.2022.
//

import Foundation

class Sound: Hashable {
    
    static func == (lhs: Sound, rhs: Sound) -> Bool {
        lhs.trackName == rhs.trackName
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(trackName)
        }
    
    internal init(name: String, imageName: String, trackName: String, category: String, isPlaying: Bool = false, isLocked: Bool) {
        self.name = name
        self.imageName = imageName
        self.trackName = trackName
        self.category = category
        self.isPlaying = isPlaying
        self.isLocked = isLocked
    }
    
    let name: String
    let imageName: String
    let trackName: String
    let category: String
    var isPlaying = false
    var isLocked: Bool
    var volume: Float = 0.5
    
    static func getAllSounds() -> [Sound] {
    [
    Sound(name: "Airplane", imageName: "source_icons_airplane-rotation", trackName: "aircraft", category: "Vehicle", isLocked: false),
     Sound(name: "Heavy rain", imageName: "source_icons_heavy-rain", trackName: "heavyrain", category: "Weather" , isLocked: false),
     Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "sea", category: "Weather"  , isLocked: false),
    ]
    }
}

//
//[
//    Sound(name: "Airplane", imageName: "source_icons_airplane-rotation", trackName: "", isLocked: false),
//    Sound(name: "Heavy rain", imageName: "source_icons_heavy-rain", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: true),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: true),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: true),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//    Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", isLocked: false),
//
//]
