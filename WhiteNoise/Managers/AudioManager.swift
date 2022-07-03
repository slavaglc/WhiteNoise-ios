//
//  AudioManager.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 09.06.2022.
//

import AVFoundation


protocol PlaybackProtocol: AnyObject {
//    var playbackState: PlaybackState { get set }
    func changeViewPlaybackState(to state: PlaybackState, for number: PlaybackViewDestination)
}

enum PlaybackState: String {
    case play = "pause_icon_hd"
    case pause = "play_icon_hd"
}

enum PlaybackViewDestination {
    case all, number(_ number: Int)
}

enum MixType {
    case current, saved
}

final class AudioManager {

    
    static let shared = AudioManager()
    
    var playbackState = PlaybackState.pause {
        didSet {
            switch playbackState {
            case .play:
                playAllSounds(mixType)
//                changeViewsState(to: playbackState, mixType: mixType)
            case .pause:
                pauseAllSounds(mixType)
            }
        }
    }
    
    var mixType: MixType = .current
    var playingNumber: Int?
    
    var players = [URL:AVAudioPlayer]()
    var playersForSavedMix = [URL: AVAudioPlayer]()
    var duplicatePlayers = [AVAudioPlayer]()
    var mainPlaybackView: PlaybackProtocol?
    var playbackViews: [PlaybackProtocol] = []
    
    
    func changePlaybackState(to state: PlaybackState, mixType: MixType, number: PlaybackViewDestination = .all) {
        self.mixType = mixType
        playbackState = state
        changeViewsState(to: state, mixType: mixType, for: number)
        
        switch number {
        case .all:
            playingNumber = nil
        case .number(let value):
            if playingNumber != value && state == .pause {
                changeViewsState(to: state, mixType: mixType, for: .all)
            }
            playingNumber = value
        }
        
//        mainPlaybackView?.changeViewPlaybackState(to: state, for: nil)
        
//        changeViewsState(to: state, mixType: mixType)
        
//        if mixType == .saved {
//            playbackViews.forEach { playbackView in
//                playbackView.changeViewPlaybackState(to: state, for: number)
//            }
//        }
        
//        if mixType == .saved {
//            playbackViews.forEach { playbackView in
//                playbackView.changeViewPlaybackState(to: state, for: number)
//            }
//        }
    }
    
    func prepareToPlay(sound: Sound, mixType: MixType = .current, completion: ()->() = {}) {

        let players = mixType == .current ? players : playersForSavedMix
        
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
                   duplicatePlayers.append(duplicatePlayer)
                   duplicatePlayer.prepareToPlay()
                   if playbackState == .play {
                       duplicatePlayer.play()
                   }
               }
           } else { //player has not been found, create a new player with the URL if possible
               do{
                   let player = try AVAudioPlayer(contentsOf: soundFileNameURL)
                   if mixType == .current {
                       self.players[soundFileNameURL] = player
                   } else {
                       playersForSavedMix[soundFileNameURL] = player
                   }
                   
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
    
    
    func playAllSounds(_ mixType: MixType = .current) {
        
        let players = mixType == .current ? players : playersForSavedMix
        
//       pauseAllSounds(mixType)
        players.forEach { playerDict in
            playerDict.value.play()
        }
        
        print("players count:", players.count)
    }
    
    func stopSounds(sounds: [Sound]) {
        sounds.forEach { sound in
            stopPlayback(sound: sound)
        }
    }
    
    func addSavedSoundsToPlayback(sounds: [Sound]) {
        sounds.forEach { sound in
            prepareToPlay(sound: sound, mixType: .saved)
        }
    }
    
    func pauseAllSounds(_ mixType: MixType) {
        if mixType == .current {
            players.forEach { playerDict in
                playerDict.value.pause()
            }
        } else {
            stopAllSounds(mixType: .saved)
        }
    }
    
    func stopAllSounds(mixType: MixType = .current) {
        if mixType == .current {
        players.forEach { playerDict in
            playerDict.value.stop()
        }
        players.removeAll()
        } else {
            playersForSavedMix.forEach { playerDict in
                playerDict.value.stop()
            }
            
            playersForSavedMix.removeAll()
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
        guard let player = mixType == .current ? players[soundFileNameURL]  : playersForSavedMix[soundFileNameURL] else { return }
        player.setVolume(0.0, fadeDuration: duration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            player.stop()
            self?.players.removeValue(forKey: soundFileNameURL)
            sound.volume = 0.5 // return to default value
            completion()
        }
    }
    
    private func changeViewsState(to state: PlaybackState, mixType: MixType, for number: PlaybackViewDestination = .all) {
//        if mixType == .current {
//            mainPlaybackView?.changeViewPlaybackState(to: state, for: nil)
//        } else {
//            playbackViews.forEach { playbackView in
//                playbackView.changeViewPlaybackState(to: state, for: number)
//                mainPlaybackView?.changeViewPlaybackState(to: state, for: nil)
//            }
//        }
        mainPlaybackView?.changeViewPlaybackState(to: state, for: .all)
        playbackViews.forEach { playbackView in
                       playbackView.changeViewPlaybackState(to: state, for: number)
//                       mainPlaybackView?.changeViewPlaybackState(to: state, for: nil)
                   }
        
    }
    
}
