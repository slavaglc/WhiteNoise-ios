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
    //Sounds
    static func getAllSounds() -> [Sound] {
    [
    Sound(name: "Airplane", imageName: "source_icons_airplane-rotation", trackName: "aircraft", category: "Vehicle", isLocked: false),
     Sound(name: "Heavy rain", imageName: "source_icons_heavy-rain", trackName: "heavyrain", category: "Weather" , isLocked: false),
     Sound(name: "Sea waves", imageName: "source_icons_sea-waves", trackName: "sea", category: "Water"  , isLocked: false),
    Sound(name: "Brown noise", imageName: "brown_noise_icon", trackName: "brownnoise", category: "Noise"  , isLocked: false),
    Sound(name: "Blue noise", imageName: "blue_noise_icon", trackName: "bluenoise", category: "Noise"  , isLocked: false),
    Sound(name: "Car", imageName: "car_icon", trackName: "car", category: "Vehicle"  , isLocked: false),
    Sound(name: "Creek", imageName: "creek_icon", trackName: "creek", category: "Water"  , isLocked: false),
    Sound(name: "Lake", imageName: "lake_icon", trackName: "lake", category: "Water"  , isLocked: false),
    Sound(name: "Ocean", imageName: "ocean_icon", trackName: "ocean", category: "Water"  , isLocked: false),
    Sound(name: "Pink noise", imageName: "pink_noise_icon", trackName: "pinknoise", category: "Noise"  , isLocked: false),
    Sound(name: "Rain", imageName: "rain_icon", trackName: "rain", category: "Rain"  , isLocked: false),
    Sound(name: "Rain on puddle", imageName: "rain_on_puddles_icon", trackName: "rainonpuddle", category: "Rain"  , isLocked: false),
    Sound(name: "Rain on leaves", imageName: "rain_on_the_leaves", trackName: "rainonleaves", category: "Rain"  , isLocked: false),
    Sound(name: "River in forest", imageName: "river_in_forest_1_icon", trackName: "forestriver", category: "Water"  , isLocked: false),
    Sound(name: "Thunderstorm", imageName: "thunderstorm_icon", trackName: "thunder", category: "Rain"  , isLocked: false),
    Sound(name: "Train", imageName: "train_icon", trackName: "train", category: "Vehicle"  , isLocked: false),
    
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
