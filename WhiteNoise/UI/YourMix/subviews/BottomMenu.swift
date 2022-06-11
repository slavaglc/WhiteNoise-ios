//
//  BottomMenu.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 28.05.2022.
//

import UIKit

final class BottomMenu: UIView {

//    private enum PlayingState: String {
//        case play = "play.fill"
//        case pause = "pause.fill"
//    }
    
    private var playingState = AudioManager.shared.playbackState {
        didSet {
            playButton.setImage(UIImage(systemName: playingState == .play ? "pause.fill" : "play.fill")?
                .scalePreservingAspectRatio(targetSize: CGSize(width: 30, height: 30)), for: .normal)
            AudioManager.shared.playbackState = playingState
        }
    }
    
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
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var playButton: SVVerticalButton = {
        let button = SVVerticalButton(type: .system)
        let image = UIImage(systemName: playingState == .play ? "pause.fill" : "play.fill" )?.scalePreservingAspectRatio(targetSize: CGSize(width: 30, height: 30)).withTintColor(#colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)) //#A2ABF1
        button.setImage(image, for: .normal)
        button.setTitle("Play", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = BarButtonType.play.rawValue
        button.tintColor =  #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)
        return button
    }()
    
    private lazy var clearButton: SVVerticalButton = {
        let button = SVVerticalButton(type: .system)
        button.tintColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)
        let image = UIImage(systemName: "xmark.circle.fill")?.scalePreservingAspectRatio(targetSize: CGSize(width: 30, height: 30)).withTintColor(#colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)) //#A2ABF1
        button.setImage(image, for: .normal)
        button.setTitle("Clear all", for: .normal)
        
//        button.tintColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1) //#A2ABF1
        
        button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = BarButtonType.mixer.rawValue
        return button
    }()
    
    private lazy var saveMixButton: SVVerticalButton = {
        let button = SVVerticalButton(type: .system)
        button.tintColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)
        let image = UIImage(named: "save_mix_icon")?
            .scalePreservingAspectRatio(targetSize: CGSize(width: 30, height: 30)).withTintColor(#colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)) //#A2ABF1
        
        button.setImage(image , for: .normal)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = BarButtonType.saveMix.rawValue
        return button
    }()
    
    private lazy var setTimerButton: SVVerticalButton = {
        let button = SVVerticalButton(type: .system)
        button.tintColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)
        let image = UIImage(named: "set_timer_icon")?.scalePreservingAspectRatio(targetSize: CGSize(width: 30, height: 30)).withTintColor(#colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)) //#A2ABF1
        button.setImage(image, for: .normal)
        button.setTitle("Set timer", for: .normal)
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
    
    
    public func setAction(for buttonType: BarButtonType, action: @escaping ()->()) {
            actions[buttonType] = action
    }
    
    public func tooglePlaybackState() {
        playingState = playingState == .play ? .pause : .play
    }
    
    @objc private func buttonPressed(button: UIButton) {
        (actions[BarButtonType.allCases[button.tag]] ??  {})()
    }
    
    private func setPrimarySettings() {
        backgroundView.addSubview(stackView)
        addSubview(backgroundView)
        stackView.addArrangedSubview(clearButton)
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(saveMixButton)
        stackView.addArrangedSubview(setTimerButton)
        setConstraints()
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
    
    
    private func getStackView(withText text: String, button: UIButton) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.font = UIFont(name: "Nunito", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)
        label.textAlignment = .center
        
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(label)
        
        return stackView
    }
    
    
}
