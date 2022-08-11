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
    
    static private var sounds: [Sound] = [
        Sound(name: "Airplane", imageName: "ventilator_1_icon_hd", trackName: "aircraft", category: "Vehicle", isLocked: false),
        Sound(name: "Heavy rain", imageName: "rainfall_icon_hd", trackName: "heavyrain", category: "Rain" , isLocked: false),
        Sound(name: "Sea waves", imageName: "ocean_icon_hd", trackName: "sea", category: "Water"  , isLocked: false),
        Sound(name: "Brown noise", imageName: "brown_noise_icon_hd", trackName: "brownnoise", category: "Noise"  , isLocked: false),
        Sound(name: "Blue noise", imageName: "blue_noise_icon_hd", trackName: "bluenoise", category: "Noise"  , isLocked: true),
        Sound(name: "Car", imageName: "car_icon_hd", trackName: "car", category: "Vehicle"  , isLocked: false),
        Sound(name: "Creek", imageName: "creek_icon_hd", trackName: "creek", category: "Water"  , isLocked: false),
        Sound(name: "Lake", imageName: "lake_icon_hd", trackName: "lake", category: "Water"  , isLocked: false),
        Sound(name: "Ocean", imageName: "ocean_icon_hd", trackName: "ocean", category: "Water"  , isLocked: true),
        Sound(name: "Pink noise", imageName: "pink_noise_icon_hd", trackName: "pinknoise", category: "Noise"  , isLocked: true),
        Sound(name: "Rain", imageName: "rain_icon_hd", trackName: "rain", category: "Rain"  , isLocked: false),
        Sound(name: "Rain on puddle", imageName: "rain_on_puddles_icon_hd", trackName: "rainonpuddle", category: "Rain"  , isLocked: false),
        Sound(name: "Rain on leaves", imageName: "rain_on_the_leaves_hd", trackName: "rainonleaves", category: "Rain"  , isLocked: false),
        Sound(name: "River in forest", imageName: "river_in_forest_1_icon_hd", trackName: "forestriver", category: "Water"  , isLocked: false),
        Sound(name: "Thunderstorm", imageName: "thunderstorm_icon_hd", trackName: "thunder", category: "Rain"  , isLocked: false),
        Sound(name: "Train", imageName: "train_icon_hd", trackName: "train", category: "Vehicle"  , isLocked: false),
        
    ]
    
    static func getAllSounds() -> [Sound] {
        sounds
    }
    
    static func unlockAllSounds(completion: ()->() = {}) {
        let sounds = Sound.getAllSounds()
        sounds.forEach { sound in
            sound.isLocked = false
        }
        completion()
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
