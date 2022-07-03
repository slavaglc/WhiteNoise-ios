//
//  MixBar.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 18.06.2022.
//

import UIKit


final class MixBar: UIView {
    
    
//    var playbackState = AudioManager.shared.playbackState {
//        didSet {
////            AudioManager.shared.mixType = .saved
////            AudioManager.shared.playbackState = playbackState
//
////            AudioManager.shared.changePlaybackState(to: playbackState, mixType: .saved)
////            playbackButton.setImage(UIImage(named: playbackState.rawValue), for: .normal)
//        }
//    }
    
    var playbackState = AudioManager.shared.playbackState
    
    
    var trackNumber: Int?
    
    private var sounds = Array<Sound>()
    
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.3254901961, alpha: 1) //#161D53
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.contentMode = .scaleToFill
        stackView.distribution = .equalCentering
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var playbackButton: UIButton = {
        let button = UIButton()
        let pauseStateImageName = PlaybackState.pause.rawValue
        let image = UIImage(named: pauseStateImageName)?.scalePreservingAspectRatio(targetSize: CGSize(width: 300, height: 300))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playSounds), for: .touchUpInside)
        return button
    }()
    
    private lazy var additionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+1", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 18)
        button.titleLabel?.textAlignment = .left
        button.tintColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)  //#A2ABF1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "playlist_options_icon")?.scalePreservingAspectRatio(targetSize: CGSize(width: 40, height: 40))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPrimarySettings()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func playSounds() {
        var playbackState = AudioManager.shared.playbackState
        let mixType = AudioManager.shared.mixType
        
        AudioManager.shared.pauseAllSounds(.current)
        AudioManager.shared.pauseAllSounds(.saved)
        
//        if playbackState == .play && mixType == .current {
//            AudioManager.shared.pauseAllSounds(.current)
//        } else if playbackState == .play && mixType == .saved {
//            AudioManager.shared.pauseAllSounds(.saved)
//        }
        
        guard let trackNumber = trackNumber else { return }
        let playingNumber = AudioManager.shared.playingNumber
        AudioManager.shared.addSavedSoundsToPlayback(sounds: sounds)
        playbackState = playbackState == .pause ? .play : .pause
        if AudioManager.shared.mixType == .current {
//            AudioManager.shared.pauseAllSounds(.current)
            playbackState = .play
        }
       
        
        
        AudioManager.shared.changePlaybackState(to: playbackState, mixType: .saved, number: .number(trackNumber))
        
    }
    
    public func setSoundsLayout() {
        let soundIconWidth: CGFloat = stackView.bounds.height
        
        removeSoundIcons()
            let possiblePlaces = (stackView.frame.width / soundIconWidth).rounded(.down)
        if !possiblePlaces.isNaN {
            let possiblePlacesInt = Int(possiblePlaces)
            (0..<possiblePlacesInt).forEach { iteration in
                if iteration < sounds.count {
                addSoundIcon(for: sounds[iteration])
                }
                let additionCount = sounds.count - possiblePlacesInt
                additionButton.isHidden = additionCount > 0 ? false : true
                additionButton.setTitle("+\(additionCount)", for: .normal)
            }
        }
    }
    
    func setMixBarParameters(for sounds: [Sound]) {
        
//        sounds.forEach { sound in
//            addSoundIcon(for: sound)
//        }
        removeSoundIcons()
        self.sounds = sounds
        
//        layoutSubviews()
    }
    
    func removeSoundIcons() {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    @objc func rotated() {
        setSoundsLayout()
    }
    
    private func setPrimarySettings() {
        AudioManager.shared.playbackViews.append(self)
        
        addSubview(backgroundView)
        backgroundView.addSubview(playbackButton)
        backgroundView.addSubview(optionsButton)
        backgroundView.addSubview(additionButton)
        backgroundView.addSubview(stackView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func setupConstraints() {
        let padding = 10.0
        
        backgroundView.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        backgroundView.heightAnchor.constraint(equalTo: heightAnchor)
            .isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
        
        playbackButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: padding)
            .isActive = true
        playbackButton.heightAnchor.constraint(equalTo: stackView.heightAnchor)
            .isActive = true
        playbackButton.widthAnchor.constraint(equalTo: playbackButton.heightAnchor)
            .isActive = true
        playbackButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
            .isActive = true
        
        additionButton.trailingAnchor.constraint(equalTo: optionsButton.leadingAnchor, constant: -padding)
            .isActive = true
        additionButton.heightAnchor.constraint(equalTo: stackView.heightAnchor)
            .isActive = true
        additionButton.widthAnchor.constraint(equalTo: additionButton.heightAnchor, multiplier: 0.5)
            .isActive = true
        additionButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
            .isActive = true
        
        optionsButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -padding)
            .isActive = true
        optionsButton.heightAnchor.constraint(equalTo: stackView.heightAnchor)
            .isActive = true
        optionsButton.widthAnchor.constraint(equalTo: optionsButton.heightAnchor)
            .isActive = true
        optionsButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
            .isActive = true
        
        
        stackView.leadingAnchor.constraint(equalTo: playbackButton.trailingAnchor, constant: (2 * padding))
            .isActive = true
        stackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: padding)
            .isActive = true
        stackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -padding)
            .isActive = true
        
        stackView.trailingAnchor.constraint(equalTo: additionButton.leadingAnchor, constant: -(padding))
            .isActive = true
    }
    
    
  
    
    private func addSoundIcon(for sound: Sound) {
        let imageBackgroundView = createImagebackgroundView()
        let imageView = createImageView()
        imageView.image = UIImage(named: sound.imageName)
        imageBackgroundView.addSubview(imageView)
        stackView.addArrangedSubview(imageBackgroundView)
        setupSoundIconConstraints(imageView: imageView, imageBackgroundView: imageBackgroundView)
    }
    
    private func createImagebackgroundView() -> ImageBackgroundView {
        let view = ImageBackgroundView()
        view.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.4509803922, alpha: 1) //#222B73
        view.layer.cornerRadius = 17
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }
    
    private func setupSoundIconConstraints(imageView: UIImageView, imageBackgroundView: ImageBackgroundView) {
        imageBackgroundView.widthAnchor.constraint(equalTo: imageBackgroundView.heightAnchor)
            .isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor)
            .isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor)
            .isActive = true
        imageView.widthAnchor.constraint(equalTo: imageBackgroundView.widthAnchor, multiplier: 0.3)
            .isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
            .isActive = true
    }
    
}

extension MixBar: PlaybackProtocol {
    func changeViewPlaybackState(to state: PlaybackState, for number: PlaybackViewDestination = .all) {
        switch number {
        case .all:
            
            if state == .pause {
                playbackButton.setImage(UIImage(named: state.rawValue), for: .normal)
            }
//            playbackButton.setImage(UIImage(named: state.rawValue), for: .normal)
        case .number(let num):
            if trackNumber == num {
            playbackButton.setImage(UIImage(named: state.rawValue), for: .normal)
            }
        }
//        playbackState = state
        
        
    }
}
