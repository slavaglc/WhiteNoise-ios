//
//  SoundCollectionViewCell.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 21.04.2022.
//

import UIKit

protocol SoundCollectionViewCellDelegate {
    func selectingVolumeBegan(in cell: SoundCollectionViewCell)
    func selectingVolumeEnded(in cell: SoundCollectionViewCell)
}

final class SoundCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            guard !touchBegan else { return }
            if isSelected {
                setBackgroundStyle(selectedStyle: .selected(animated: false, volume: sound.volume))
            } else {
                setBackgroundStyle(selectedStyle: .unselected(animated: false))
            }
        }
    }
        
    public var delegate: SoundCollectionViewCellDelegate?
    
  
    
    private var sound: Sound = Sound(name: "Placholder Sound", imageName: "", trackName: "", category: "", isLocked: false)
    private var volumeIsSelecting = false {
        didSet {
            touchBegan = volumeIsSelecting
            if isSelected {
                setVolumeStyle()
            } else {
                volumeIsSelecting = false
            }
        }
    }
    private var touchBegan = false
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageBackgroundView: ImageBackgroundView  = {
        let view = ImageBackgroundView(withVolumeControl: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nunito", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var soundLockImage: UIImageView = {
        let image = UIImage(named: "sound_lock_icon_hd")
        let imageView = UIImageView(image: image)
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageBackgroundView.isHidden = true
        label.text?.removeAll()
        imageView.image = nil
        setBackgroundStyle(selectedStyle: .unselected(animated: false))
    }
    
    
    @objc func longPressed(gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .possible:
            touchBegan = true
        case .began:
            guard !sound.isLocked else { return }
            touchBegan = true
            delegate?.selectingVolumeBegan(in: self)
            setVolumeState(by: gesture.location(in: imageBackgroundView))
            volumeIsSelecting = true
        case .changed:
            guard !sound.isLocked else { return }
            setVolumeState(by: gesture.location(in: imageBackgroundView))
        case .ended:
            volumeIsSelecting = false
            let width = gesture.location(in: imageBackgroundView).x
            if width <= 0 {
                delegate?.selectingVolumeEnded(in: self)
            }
        case .cancelled:
            volumeIsSelecting = false
        case .failed:
            volumeIsSelecting = false
        default:
            break
        }
    }
    
    private func setVolumeState(by location: CGPoint) {
        guard volumeIsSelecting else { return }
        guard location.x >= 0 else { return }
        imageBackgroundView.setVolumeState(by: location, for: &sound.volume)
        AudioManager.shared.setVolume(for: sound)
    }
    

    public func setCellParameters(sound: Sound) {
        self.sound = sound
        imageBackgroundView.isHidden = false
        let image = UIImage(named: sound.imageName)
        imageView.image = image?.tint(with: isSelected ? .white  : .lightGray)
        label.text = sound.name
        soundLockImage.isHidden = !sound.isLocked
    }
    
    public func getFontHeight() -> CGFloat {
        label.font.lineHeight
    }
    
    private func initialize() {
        imageBackgroundView.addSubview(imageView)
        imageBackgroundView.addSubview(soundLockImage)
        stackView.addArrangedSubview(imageBackgroundView)
        stackView.addArrangedSubview(label)
        contentView.addSubview(stackView)
        
        setGesturesSettings()
        setupConstraints()
    }
    
    private func setGesturesSettings() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(gesture:)))
        longPressGesture.minimumPressDuration = 0.1
        addGestureRecognizer(longPressGesture)
    }
    
    private func setupConstraints() {
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            .isActive = true
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            .isActive = true
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
            .isActive = true
        stackView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
            .isActive = true
        

        imageBackgroundView.heightAnchor.constraint(equalTo: imageBackgroundView.widthAnchor)
            .isActive = true
        imageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor)
            .isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor)
            .isActive = true
        imageView.widthAnchor.constraint(equalTo: imageBackgroundView.widthAnchor, multiplier: 0.3)
            .isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
            .isActive = true
        
        soundLockImage.heightAnchor.constraint(equalToConstant: 24)
            .isActive = true
        soundLockImage.widthAnchor.constraint(equalTo: soundLockImage.heightAnchor)
            .isActive = true
        soundLockImage.topAnchor.constraint(equalTo: imageBackgroundView.topAnchor, constant: 6)
            .isActive = true
        soundLockImage.trailingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor, constant: -6)
            .isActive = true
    }
    
    
    // MARK: - Graphics and animation methods
    
    func setVolumeStyle() {
        if volumeIsSelecting {
            imageView.image = UIImage(named: "sound_volume_icon")
            HapticManager.shared.notify(notificationType: .warning)
        } else {
            imageView.image = UIImage(named: sound.imageName)?.tint(with: isSelected ? .white : .lightGray)
        }
    }
    
    func setBackgroundStyle(selectedStyle: SelectedStyle) {
        switch selectedStyle {
        case .selected(animated: let animated, volume: _):
            if animated  && !touchBegan { animateSelection(duration: 0.8, withStyle: selectedStyle) } else {
                
                let volume = touchBegan ? getCurrentVolumePosition() : sound.volume
            imageBackgroundView.setStyle(selectedStyle: SelectedStyle.selected(animated: false, volume: volume))
            imageView.image = imageView.image?.tint(with: .white)
            }
        case .unselected(_):
            imageBackgroundView.setStyle(selectedStyle: selectedStyle)
            imageView.image = imageView.image?.tint(with: .lightGray)
        }
    }
    
    private func  getCurrentVolumePosition() -> Float {
        guard let gestureRecognizer = gestureRecognizers?.last else { return 0.0 }
        let locationX =  gestureRecognizer.location(in: imageBackgroundView).x
        let position = Float(locationX / imageBackgroundView.frame.width)
        return position
    }
    
    private func animateSelection(duration: Double, withStyle selectedStyle: SelectedStyle) {
        guard gestureRecognizers?.first?.state != .began else { return }
        isUserInteractionEnabled = false
        imageBackgroundView.setStyle(selectedStyle: selectedStyle)
        let soundImage = imageView.image
        imageView.image = UIImage(named: "sound_volume_icon")

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.imageView.image = soundImage?.withTintColor(.white)
            self?.isUserInteractionEnabled = true
        }

//        UIView.animate(withDuration: 0.3) { [unowned self] in
//            imageBackgroundView.transform = imageBackgroundView.transform.scaledBy(x: 0.9, y: 0.9)
//        } completion: { [weak self] isFinished in
//            if isFinished {
//                print("finished")
//                self?.returnSizeAnimation(withStyle: selectedStyle)
//            }
//        }
    }
//
//    private func returnSizeAnimation(withStyle selectedStyle: SelectedStyle) {
//        UIView.animate(withDuration: 0.25) { [unowned self] in
//            imageBackgroundView.transform = imageBackgroundView.transform.scaledBy(x: 1.1, y: 1.1)
//        } completion: { [weak self] isFinished in
//            if isFinished {
//                self?.imageBackgroundView.setStyle(selectedStyle: selectedStyle)
//            }
//        }
//    }
}

