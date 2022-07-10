//
//  SoundCollectionViewCell.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 21.04.2022.
//

import UIKit

final class SoundCollectionViewCell: UICollectionViewCell, CAAnimationDelegate {
    
    override var isSelected: Bool {
        didSet {
            colorIndex = 0
            if isSelected {
                setBackgroundStyle(selectedStyle: .selected(animated: false))
            } else {
                setBackgroundStyle(selectedStyle: .unselected(animated: false))
            }
        }
    }
        
    private let opacityAnimation = CABasicAnimation(keyPath: "opacity")
    
    private let color1: CGColor = #colorLiteral(red: 0.4901960784, green: 0.3254901961, blue: 0.8352941176, alpha: 1).cgColor
    private  let color2: CGColor = #colorLiteral(red: 0.7745779157, green: 0.7195857167, blue: 1, alpha: 1).cgColor
    private   let color3: CGColor = #colorLiteral(red: 0.5406857133, green: 0.4216250181, blue: 1, alpha: 1).cgColor
    
//    private  let gradient: CAGradientLayer = CAGradientLayer()
    private var gradientColorSet: [[CGColor]] = []
    private var colorIndex: Int = 0
    
    private lazy var gradientLayer: CAGradientLayer = {
        CAGradientLayer()
    }()
    
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
    

    public func setCellParameters(sound: Sound) {
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
        setupConstraints()
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
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if flag {
//            if isSelected {
//                setupGradientForSelected()
//            }
//        }
//    }
    
//    func setSelectedStyle() {
//        self.gradientLayer.frame = self.imageBackgroundView.bounds
//        animateGradient()
//        gradientLayer.shouldRasterize = true
//    }
//
//
//    func setUnselectedStyle() {
//        imageBackgroundView.layer.addSublayer(gradientLayer)
//        imageBackgroundView.bringSubviewToFront(imageView)
//        imageBackgroundView.bringSubviewToFront(soundLockImage)
//        imageView.image = imageView.image?.tint(with: .lightGray)
//        gradientLayer.shouldRasterize = true
//        animateGradientDissapearing()
//    }
    
    
    func setBackgroundStyle(selectedStyle: SelectedStyle) {
        imageBackgroundView.setStyle(selectedStyle: selectedStyle)
        switch selectedStyle {
        case .selected(_):
            imageView.image = imageView.image?.tint(with: .white)
        case .unselected(_):
            imageView.image = imageView.image?.tint(with: .lightGray)
        }
        
        
//        imageBackgroundView.layer.addSublayer(gradientLayer)
//        imageBackgroundView.bringSubviewToFront(imageView)
//        imageBackgroundView.bringSubviewToFront(soundLockImage)
//        gradientColorSet = [
//            [color1, color2],
//            [color2, color3],
//            [color3, color1]
//        ]
//
//        gradientLayer.frame = imageBackgroundView.bounds
//        gradientLayer.colors = gradientColorSet[0]
    }
    
    private func setupGradientForUnselected() {
        gradientLayer.removeFromSuperlayer()
        imageView.image = imageView.image?.tint(with: .lightGray)
    }
//    
//   private func animateGradient() {
//        gradientLayer.colors = gradientColorSet[colorIndex]
//        let gradientAnimation = CABasicAnimation(keyPath: "colors")
//        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
//    
//        gradientAnimation.delegate = self
//        gradientAnimation.duration = 0.3
//        
//        opacityAnimation.delegate = self
//        opacityAnimation.duration = 0.1
//        opacityAnimation.toValue = 1
//        opacityAnimation.fillMode = .forwards
//        opacityAnimation.isRemovedOnCompletion = false
//        gradientLayer.add(opacityAnimation, forKey: "opacity")
//        
//           updateColorIndex()
//           gradientAnimation.toValue = gradientColorSet[colorIndex]
//           
//           gradientAnimation.fillMode = .forwards
//           gradientAnimation.isRemovedOnCompletion = false
//        
//        opacityAnimation.fillMode = .forwards
//        opacityAnimation.isRemovedOnCompletion = false
//        gradientLayer.add(opacityAnimation, forKey: "opacity")
//        
//        gradientLayer.add(gradientAnimation, forKey: "colors")
//       }
//       
//       func updateColorIndex() {
//           if colorIndex < gradientColorSet.count - 1 {
//               colorIndex += 1
//           } else {
//               colorIndex = 0
//           }
//       }
    
   private func animateGradientDissapearing() {
        opacityAnimation.delegate = self
        opacityAnimation.duration = 0.15
        opacityAnimation.toValue = 0
        opacityAnimation.fillMode = .forwards
        opacityAnimation.isRemovedOnCompletion = false
        gradientLayer.add(opacityAnimation, forKey: "opacity")
    }
    
}
