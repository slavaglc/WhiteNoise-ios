//
//  ThirdPage.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 23.07.2022.
//

import UIKit


final class ThirdPage: UIView {
    
    
    private lazy var backgroundImageView: UIImageView = {
        let bounds = UIScreen.main.bounds
        let backgroundImage = UIImage(named: "ThirdScreenBackground")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .top
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-SemiBold", size: 24)
        label.textColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1)  //#DCE0FF
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Combine several sounds to find the best one for your baby"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPrimarySettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setPrimarySettings() {
        addSubview(backgroundImageView)
        addSubview(label)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding = 19.0
        let height = 120.0
        
        backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: label.topAnchor)
            .isActive = true

        
        label.heightAnchor.constraint(equalToConstant: height)
            .isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            .isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
            .isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
            .isActive = true
        
    }
    
}

