//
//  MixBar.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 18.06.2022.
//

import UIKit


final class MixBar: UIView {
    
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
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPrimarySettings()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPrimarySettings() {
        addSubview(backgroundView)
        backgroundView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        backgroundView.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        backgroundView.heightAnchor.constraint(equalTo: heightAnchor)
            .isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
        
        
        stackView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.9)
            .isActive = true
        
        stackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10)
            .isActive = true
        
        stackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10)
            .isActive = true
        stackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
            .isActive = true // temporally
    }
    
    func setMixBarParameters(for sounds: [Sound]) {
        sounds.forEach { sound in
            addSoundIcon(for: sound)
        }
    }
    
    func removeSoundIcons() {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
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
//        imageBackgroundView.heightAnchor.constraint(equalTo: imageBackgroundView.widthAnchor)
//            .isActive = true
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
