//
//  CustomTabBar.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 22.04.2022.
//

import UIKit



final class CustomTabBar: UIView {
    
    private enum PlayingState: String {
        case play = "play_icon"
        case pause = "pause_icon"
    }
    
    private var playingState = PlayingState.play {
        didSet {
            playButton.setImage(UIImage(named: playingState.rawValue), for: .normal)
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.contentMode = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.layer.cornerRadius = 25
        stackView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1529411765, blue: 0.4039215686, alpha: 1)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: playingState.rawValue), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var mixerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "mixer_icon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveMixButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "save_mix_icon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var setTimerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "set_timer_icon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func setPrimarySettings() {
        addSubview(stackView)
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(mixerButton)
        stackView.addArrangedSubview(saveMixButton)
        stackView.addArrangedSubview(setTimerButton)
        setConstraints()
    }
    
    private func setConstraints() {
        stackView.heightAnchor.constraint(equalTo: heightAnchor)
            .isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
//        playButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.8)
//            .isActive = true
//        playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor)
//            .isActive = true
    }
    
}
