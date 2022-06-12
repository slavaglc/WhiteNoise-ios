//
//  AudioManager.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 09.06.2022.
//

import AVFoundation


enum PlayingState: String {
    case play = "pause_icon_hd"
    case pause = "play_icon_hd"
    
}

final class AudioManager {

    
    static let shared = AudioManager()
    
    var playbackState = PlayingState.pause {
        didSet {
            switch playbackState {
            case .play:
                playAllSounds()
            case .pause:
                pauseAllSounds()
            }
        }
    }
    
    
    var players = [URL:AVAudioPlayer]()
    var duplicatePlayers = [AVAudioPlayer]()
    
    
    func prepareToPlay(sound: Sound, completion: ()->() = {}) {

        sound.isPlaying = true
        let soundFileNameURL = URL(fileURLWithPath: Bundle.main.path(forResource: sound.trackName, ofType: "wav")!)
        guard !players.contains(where: { element in
            element.key == soundFileNameURL
        }) else { return }

           if let player = players[soundFileNameURL] { //player for sound has been found
               if player.isPlaying == false { //player is not in use, so use that one
                   player.numberOfLoops = -1
                   player.volume = sound.volume
                   player.prepareToPlay()
                   if playbackState == .play {
                       player.play()
                   }

               } else { // player is in use, create a new, duplicate, player and use that instead

                   let duplicatePlayer = try! AVAudioPlayer(contentsOf: soundFileNameURL as URL)
                   //use 'try!' because we know the URL worked before.

//                   duplicatePlayer.delegate = self
                   //assign delegate for duplicatePlayer so delegate can remove the duplicate once it's stopped playing

                   duplicatePlayers.append(duplicatePlayer)
                   //add duplicate to array so it doesn't get removed from memory before finishing

                   duplicatePlayer.prepareToPlay()
                   if playbackState == .play {
                       duplicatePlayer.play()
                   }
               }
           } else { //player has not been found, create a new player with the URL if possible
               do{
                   let player = try AVAudioPlayer(contentsOf: soundFileNameURL)
                   players[soundFileNameURL] = player
                   player.volume = sound.volume
                   player.numberOfLoops = -1
                   player.prepareToPlay()
                   if playbackState == .play {
                       player.play()
                   }
               } catch {
                   print("Could not play sound file!")
               }
           }
        completion()
       }
    
    
    func playAllSounds() {
        players.forEach { playerDict in
            playerDict.value.play()
        }
    }
    
    func stopSounds(sounds: [Sound]) {
        sounds.forEach { sound in
            stopPlayback(sound: sound)
        }
    }
    
    func pauseAllSounds() {
        players.forEach { playerDict in
            playerDict.value.pause()
        }
    }
    
    func stopPlayback(sound: Sound, completion: @escaping ()->() = {}) {
        sound.isPlaying = false
        smoothlyStop(sound: sound, duration: 0.7, completion: completion)
    }
    
    func setVolume(for sound: Sound) {
        let soundFileNameURL = URL(fileURLWithPath: Bundle.main.path(forResource: sound.trackName, ofType: "wav")!)
        guard let player = players[soundFileNameURL] else { return }
        player.setVolume(sound.volume, fadeDuration: 1)
    }
    
    private func smoothlyStop(sound: Sound, duration: Double, completion: @escaping ()->() = {}) {
        let soundFileNameURL = URL(fileURLWithPath: Bundle.main.path(forResource: sound.trackName, ofType: "wav")!)
        guard let player = players[soundFileNameURL] else { return }
        player.setVolume(0.0, fadeDuration: duration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            player.stop()
            self?.players.removeValue(forKey: soundFileNameURL)
            sound.volume = 0.5 // return to default value
            completion()
        }
    }
    
}
