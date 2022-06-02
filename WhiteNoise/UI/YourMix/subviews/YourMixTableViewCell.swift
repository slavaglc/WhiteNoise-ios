//
//  YourMixTableViewCell.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 27.05.2022.
//

import UIKit

final class YourMixTableViewCell: UITableViewCell {

    private var sound: Sound?
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var soundBackgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageBackgroundView: ImageBackgroundView = {
        let view = ImageBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var soundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        let tgl = CAGradientLayer()
          let frame = CGRect.init(x:0, y:0, width:slider.frame.size.width, height:5)
          tgl.frame = frame
          tgl.colors = [#colorLiteral(red: 0.7882352941, green: 0.6352941176, blue: 0.9450980392, alpha: 1).cgColor, #colorLiteral(red: 0.4549019608, green: 0.2196078431, blue: 0.9568627451, alpha: 1).cgColor] //#C9A2F1 #7438F4
          tgl.startPoint = CGPoint.init(x:0.0, y:0.5)
          tgl.endPoint = CGPoint.init(x:1.0, y:0.5)

          UIGraphicsBeginImageContextWithOptions(tgl.frame.size, tgl.isOpaque, 0.0);
          tgl.render(in: UIGraphicsGetCurrentContext()!)
          if let image = UIGraphicsGetImageFromCurrentImageContext() {
              UIGraphicsEndImageContext()
              image.resizableImage(withCapInsets: UIEdgeInsets.zero)
              slider.setMinimumTrackImage(image, for: .normal)
          }
        
        slider.thumbTintColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1) // #A2ABF1
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        return slider
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
    
    private lazy var removeButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "CloseButton"))
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeButtonTapped))
        imageView.addGestureRecognizer(tap)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setPrimarySettings()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setPrimarySettings()
        setupConstraints()
    }
    // MARK: - Actions
    @objc private func removeButtonTapped() {
        sound?.isPlaying = false
    }
    
    @objc private func sliderValueChanged() {
        sound?.volume = volumeSlider.value
    }
    
    public func setCellParameters(sound: Sound)  {
        self.sound = sound
        label.text = sound.name
        soundImageView.image = UIImage(named: sound.imageName)
        volumeSlider.value = sound.volume
    }
    
    
    private func setPrimarySettings() {
        backgroundColor = .clear
        selectionStyle = .none
        isUserInteractionEnabled = true
        soundBackgroundStackView.addArrangedSubview(imageBackgroundView)
        soundBackgroundStackView.addArrangedSubview(label)
        
        imageBackgroundView.addSubview(soundImageView)
        horizontalStackView.addArrangedSubview(volumeSlider)
        horizontalStackView.addArrangedSubview(removeButton)
        contentView.addSubview(soundBackgroundStackView)
        contentView.addSubview(horizontalStackView)
    }
    
    private func setupConstraints() {
        let padding = 10.0
        horizontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
        horizontalStackView.heightAnchor.constraint(equalTo: heightAnchor)
            .isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: soundBackgroundStackView.trailingAnchor, constant: padding)
            .isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
            .isActive = true
        
        
        
        imageBackgroundView.heightAnchor.constraint(equalToConstant: 85)
            .isActive = true
        imageBackgroundView.widthAnchor.constraint(equalTo: imageBackgroundView.heightAnchor)
            .isActive = true
        imageBackgroundView.centerYAnchor.constraint(equalTo: volumeSlider.centerYAnchor)
        
            .isActive = true
        
        
        
        soundImageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor)
          .isActive = true
        soundImageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor)
          .isActive = true
        soundImageView.widthAnchor.constraint(equalTo: imageBackgroundView.widthAnchor, multiplier: 0.3)
          .isActive = true
        soundImageView.heightAnchor.constraint(equalTo: soundImageView.widthAnchor)
            .isActive = true
        
        
        soundBackgroundStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            .isActive = true
        
        
        removeButton.heightAnchor.constraint(equalToConstant: 40)
            .isActive = true
        
    }
    

}
