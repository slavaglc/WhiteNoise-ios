//
//  CustomTabBar.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 22.04.2022.
//

import UIKit



enum BarButtonType: Int, CaseIterable {
    case play, mixer, saveMix, timer, clearAll
}

final class CustomTabBar: UIView  {
    
//    var playbackState = AudioManager.shared.playbackState {
//        didSet {
////            AudioManager.shared.mixType = .current
////            AudioManager.shared.playbackState = playbackState
//
////            AudioManager.shared.changePlaybackState(to: playbackState, mixType: .current)
////            playButton.setImage(UIImage(named: playbackState.rawValue), for: .normal)
//        }
//    }
    
    private var actions: [BarButtonType: ()->()] = [:]
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.contentMode = .scaleToFill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1529411765, blue: 0.4039215686, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: playbackState.rawValue), for: .normal)
        let playbackState = AudioManager.shared.playbackState
        button.setImage(UIImage(named: playbackState.rawValue), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = BarButtonType.play.rawValue
        return button
    }()
    
    private lazy var mixerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "mixer_icon_hd"), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = BarButtonType.mixer.rawValue
        return button
    }()
    
    private lazy var mixerButtonBadge: UICircle = {
        let badge = UICircle()
        badge.isHidden = true
        badge.isUserInteractionEnabled = false
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.6352941176, blue: 0.9450980392, alpha: 1)
        return badge
    }()
    
    private lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Nunito-Bold", size: 12)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var saveMixButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "save_mix_icon_hd"), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = BarButtonType.saveMix.rawValue
        return button
    }()
    
    private lazy var setTimerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "set_timer_icon_hd"), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = BarButtonType.timer.rawValue
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPrimarySettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setPrimarySettings()
    }
    
    public func setNumberForBadge(number: Int) {
        mixerButtonBadge.isHidden = number <= 0
        badgeLabel.text = number <= 10000 ? String(number) : "10K+"
    }
    
    public func hideBadge() {
        mixerButtonBadge.isHidden = true
    }
    
    public func setAction(for buttonType: BarButtonType, action: @escaping ()->()) {
            actions[buttonType] = action
    }
    
    public func togglePlaybackState() {
//        AudioManager.shared.playbackState = playingState
//        playbackState = playbackState == .play ? .pause : .play
        let playbackState = AudioManager.shared.playbackState
        
        AudioManager.shared.pauseAllSounds(.saved)
        AudioManager.shared.changePlaybackState(to: playbackState == .play ? .pause : .play, mixType: .current)
    }
    
    public func setPlaybackState() {
//        playbackState = AudioManager.shared.playbackState
    }
    
    @objc private func buttonPressed(button: UIButton) {
        (actions[BarButtonType.allCases[button.tag]] ??  {})()
    }
    
    private func setPrimarySettings() {
        AudioManager.shared.mainPlaybackView = self
        
        backgroundView.addSubview(stackView)
        addSubview(backgroundView)
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(mixerButton)
        stackView.addArrangedSubview(saveMixButton)
        stackView.addArrangedSubview(setTimerButton)
        setConstraints()
        setupBadgeForMixerButton()
    }
    
    private func setConstraints() {
        backgroundView.heightAnchor.constraint(equalTo: heightAnchor)
            .isActive = true
        backgroundView.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        stackView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor)
            .isActive = true
        stackView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.95)
            .isActive = true
        stackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
            .isActive = true
    }
    
    private func setupBadgeForMixerButton() {
        mixerButton.addSubview(mixerButtonBadge)
        mixerButtonBadge.addSubview(badgeLabel)
        mixerButtonBadge.bringSubviewToFront(badgeLabel)
        mixerButtonBadge.centerXAnchor.constraint(equalTo: mixerButton.trailingAnchor, constant: -12)
            .isActive = true
        mixerButtonBadge.topAnchor.constraint(equalTo: mixerButton.topAnchor, constant: 12)
            .isActive = true
        mixerButtonBadge.heightAnchor.constraint(equalTo: mixerButton.heightAnchor, multiplier: 0.3)
            .isActive = true
        mixerButtonBadge.widthAnchor.constraint(greaterThanOrEqualTo: mixerButtonBadge.heightAnchor)
            .isActive = true
        
        badgeLabel.centerXAnchor.constraint(equalTo: mixerButtonBadge.centerXAnchor)
            .isActive = true
        badgeLabel.centerYAnchor.constraint(equalTo: mixerButtonBadge.centerYAnchor)
            .isActive = true
        badgeLabel.heightAnchor.constraint(equalTo: mixerButtonBadge.heightAnchor, multiplier: 0.8)
            .isActive = true
        badgeLabel.widthAnchor.constraint(equalTo: mixerButtonBadge.widthAnchor, multiplier: 0.8)
            .isActive = true
    }
}

extension CustomTabBar: PlaybackProtocol {
    func changeViewPlaybackState(to state: PlaybackState, for number: PlaybackViewDestination = .all) {
        playButton.setImage(UIImage(named: state.rawValue), for: .normal)
    }
    
    
}


