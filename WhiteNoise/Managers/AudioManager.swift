//
//  AudioManager.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 09.06.2022.
//

import AVFoundation


final class AudioManager {

    
    static let shared = AudioManager()
    
//    private var player: AVAudioPlayer?
//    private var sounds = Set<Sound>()
    var players = [URL:AVAudioPlayer]()
    var duplicatePlayers = [AVAudioPlayer]()
    
    
//    func playSound(sound: Sound) {
//        do {
//            sound.isPlaying = true
//            let urlString = Bundle.main.path(forResource: sound.trackName, ofType: "wav")
//
//            try AVAudioSession.sharedInstance().setMode(.default)
//            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
//
//            guard let urlString = urlString else {
//                return
//            }
//
//            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
//            player?.numberOfLoops = -1
//            guard let player = player else {
//                return
//            }
//
//            player.play()
//
//
//        } catch {
//            print("Error with playing sound")
//        }
//    }
    
    func playSound(sound: Sound){

        sound.isPlaying = true
        let soundFileNameURL = URL(fileURLWithPath: Bundle.main.path(forResource: sound.trackName, ofType: "wav")!)

           if let player = players[soundFileNameURL] { //player for sound has been found
               if player.isPlaying == false { //player is not in use, so use that one
                   player.numberOfLoops = -1
                   player.volume = sound.volume
                   player.prepareToPlay()
                   player.play()

               } else { // player is in use, create a new, duplicate, player and use that instead

                   let duplicatePlayer = try! AVAudioPlayer(contentsOf: soundFileNameURL as URL)
                   //use 'try!' because we know the URL worked before.

//                   duplicatePlayer.delegate = self
                   //assign delegate for duplicatePlayer so delegate can remove the duplicate once it's stopped playing

                   duplicatePlayers.append(duplicatePlayer)
                   //add duplicate to array so it doesn't get removed from memory before finishing

                   duplicatePlayer.prepareToPlay()
                   duplicatePlayer.play()

               }
           } else { //player has not been found, create a new player with the URL if possible
               do{
                   let player = try AVAudioPlayer(contentsOf: soundFileNameURL)
                   players[soundFileNameURL] = player
                   player.volume = sound.volume
                   player.numberOfLoops = -1
                   player.prepareToPlay()
                   player.play()
               } catch {
                   print("Could not play sound file!")
               }
           }
       }
    
//    func appendToPlayer(sound: Sound) {
//        let soundFileNameURL = URL(fileURLWithPath: Bundle.main.path(forResource: sound.trackName, ofType: "wav")!)
//
//    }
    
    func stopPlayback(sound: Sound) {
        smoothlyStop(sound: sound, duration: 0.7)
        sound.isPlaying = false
    }
    
    func setVolume(for sound: Sound) {
        let soundFileNameURL = URL(fileURLWithPath: Bundle.main.path(forResource: sound.trackName, ofType: "wav")!)
        guard let player = players[soundFileNameURL] else { return }
        player.setVolume(sound.volume, fadeDuration: 1)
    }
    
    private func smoothlyStop(sound: Sound, duration: Double) {
        let soundFileNameURL = URL(fileURLWithPath: Bundle.main.path(forResource: sound.trackName, ofType: "wav")!)
        guard let player = players[soundFileNameURL] else { return }
        player.setVolume(0.0, fadeDuration: duration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            player.stop()
            self?.players.removeValue(forKey: soundFileNameURL)
            sound.volume = 0.5 // return to default value
        }
    }
    
}
