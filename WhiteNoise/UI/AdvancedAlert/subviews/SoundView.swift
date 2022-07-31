//
//  SoundView.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 31.07.2022.
//

import UIKit


final class SoundView: UIView {
    
    private var sound: Sound?
    private var sideOfSquare: CGFloat = .zero
    
    private lazy var soundBackgroundView: ImageBackgroundView = {
        let imageBacgroundView = ImageBackgroundView()
        imageBacgroundView.setStyle(selectedStyle: .selected(animated: false, volume: 1.0))
        imageBacgroundView.translatesAutoresizingMaskIntoConstraints = false
        return imageBacgroundView
    }()
    
    private lazy var imageView: UIImageView = {
        guard let sound = sound else { return UIImageView()}
        let tintColor = #colorLiteral(red: 0.9450980392, green: 0.9137254902, blue: 1, alpha: 1)  //#F1E9FF
        let image = UIImage(named: sound.imageName)?.withTintColor(tintColor)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var soundLockImage: UIImageView = {
        let image = UIImage(named: "sound_lock_icon_hd")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let sound = sound { imageView.isHidden = !sound.isLocked }
        return imageView
    }()
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(sound: Sound, sideOfSquare: CGFloat = .zero) {
        self.init()
        self.sound = sound
        self.sideOfSquare = sideOfSquare
        setPrimarySettings()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPrimarySettings() {
        soundBackgroundView.addSubview(imageView)
        soundBackgroundView.addSubview(soundLockImage)
        addSubview(soundBackgroundView)
        soundBackgroundView.setStyle(selectedStyle: .selected(animated: false, volume: 1.0))
    }
    
    private func setupConstraints() {
        widthAnchor.constraint(equalToConstant: sideOfSquare)
            .isActive = true
        heightAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        soundBackgroundView.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        soundBackgroundView.heightAnchor.constraint(equalTo: soundBackgroundView.widthAnchor)
            .isActive = true
        soundBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        soundBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: soundBackgroundView.centerXAnchor)
            .isActive = true
        imageView.centerYAnchor.constraint(equalTo: soundBackgroundView.centerYAnchor)
            .isActive = true
        
        soundLockImage.heightAnchor.constraint(equalToConstant: 24)
            .isActive = true
        soundLockImage.widthAnchor.constraint(equalTo: soundLockImage.heightAnchor)
            .isActive = true
        soundLockImage.topAnchor.constraint(equalTo:  soundBackgroundView.topAnchor, constant: 6)
            .isActive = true
        soundLockImage.trailingAnchor.constraint(equalTo: soundBackgroundView.trailingAnchor, constant: -6)
            .isActive = true
    }
    
}
