//
//  ReviewView.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 23.07.2022.
//

import UIKit


final class ReviewView: UIView {
    
    private var reviewText: String?
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let frameView: UIView = {
        let view = UIView()
        view.layer.borderColor  = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.3254901961, alpha: 1)  //#161D53
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 17
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private  lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Nunito-SemiBold", size: 18)
        label.textColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1)  //#DCE0FF
        label.text = reviewText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(review: Review) {
        self.init()
        reviewText = review.reviewText
        setPrimarySettings()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPrimarySettings() {
        frameView.addSubview(reviewLabel)
        backgroundView.addSubview(frameView)
        addSubview(backgroundView)
        reviewLabel.text = reviewText
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding = 12.0
        let backgroundViewPadding = 16.0
        
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor)
            .isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
            .isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor)
            .isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
            .isActive = true
        
        frameView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: backgroundViewPadding)
            .isActive = true
        frameView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -backgroundViewPadding)
            .isActive = true
        frameView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: backgroundViewPadding)
            .isActive = true
        frameView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -backgroundViewPadding)
            .isActive = true
        
        reviewLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: padding)
            .isActive = true
        reviewLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -padding)
            .isActive = true
        reviewLabel.topAnchor.constraint(equalTo: frameView.topAnchor, constant: padding)
            .isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: frameView.bottomAnchor, constant: -padding)
            .isActive = true
    }
    
}
