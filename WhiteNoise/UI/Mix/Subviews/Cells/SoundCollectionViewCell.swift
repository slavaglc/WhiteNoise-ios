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
            colorIndex = 0
            if isSelected {
                setBackgroundStyle(selectedStyle: .selected(animated: false, volume: sound.volume))
            } else {
                setBackgroundStyle(selectedStyle: .unselected(animated: false))
            }
        }
    }
        
    public var delegate: SoundCollectionViewCellDelegate?
    
    private let opacityAnimation = CABasicAnimation(keyPath: "opacity")
    
    private let color1: CGColor = #colorLiteral(red: 0.4901960784, green: 0.3254901961, blue: 0.8352941176, alpha: 1).cgColor
    private  let color2: CGColor = #colorLiteral(red: 0.7745779157, green: 0.7195857167, blue: 1, alpha: 1).cgColor
    private   let color3: CGColor = #colorLiteral(red: 0.5406857133, green: 0.4216250181, blue: 1, alpha: 1).cgColor
    
    private var sound: Sound = Sound(name: "Placholder Sound", imageName: "", trackName: "", category: "", isLocked: false)
    
//    private  let gradient: CAGradientLayer = CAGradientLayer()
    
    private var gradientColorSet: [[CGColor]] = []
    private var colorIndex: Int = 0
    private var volumeIsSelecting = false {
        didSet {
            if isSelected {
                setVolumeStyle()
            } else {
                volumeIsSelecting = false
            }
            
        }
    }
//    private lazy var gradientLayer: CAGradientLayer = {
//        CAGradientLayer()
//    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageBackgroundView: ImageBackgroundView  = {
        let view = ImageBackgroundView()
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
        let image = UIImage(named: "sound_lock_icon")
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
        case .began:
            delegate?.selectingVolumeBegan(in: self)
            volumeIsSelecting = true
        case .changed:
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
        longPressGesture.minimumPressDuration = 0.3
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
        //            print("volume in Cell:", sound.volume)
        imageBackgroundView.setStyle(selectedStyle: selectedStyle)
        
        
        switch selectedStyle {
        case .selected(animated: _):
            imageView.image = imageView.image?.tint(with: .white)
        case .unselected(_):
            imageView.image = imageView.image?.tint(with: .lightGray)
        }
        
    }
}
