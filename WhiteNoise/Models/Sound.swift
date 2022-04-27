//
//  Sound.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 20.04.2022.
//

import Foundation

struct Sound {
    let name: String
    let imageName: String
    let trackName: String
    let category: String
    var isLocked: Bool
    
    static func getAllSounds() -> [Sound] {
    [
    Sound(name: "Airplane", imageName: "source_icons_airplane-rotation", trackName: "", category: "Vehicle", isLocked: false),
     Sound(name: "Heavy rain", imageName: "source_icons_heavy-rain", trackName: "", category: "Weather" , isLocked: false),
     Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", category: "Weather"  , isLocked: false),
     Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", category: "Weather"  , isLocked: false),
     Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", category: "Weather"  , isLocked: false),
     Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", category: "Weather"  , isLocked: false),
     Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", category: "Weather"  , isLocked: false),
     Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "", category: "Weather"  , isLocked: false)
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
