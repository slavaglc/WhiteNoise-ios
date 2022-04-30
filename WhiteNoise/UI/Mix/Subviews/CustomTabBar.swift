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
    
    public func setNumberForBadge(number: Int) {
        mixerButtonBadge.isHidden = false
        badgeLabel.text = number <= 10000 ? String(number) : "10K+"
    }
    
    public func hideBadge() {
        mixerButtonBadge.isHidden = true
    }
    
    private func setPrimarySettings() {
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
