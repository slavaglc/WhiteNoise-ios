//
//  WelcomeViewController.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 22.07.2022.
//

import UIKit


final class WelcomeViewController: UIViewController {
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let bounds = UIScreen.main.bounds
        let backgroundImage = UIImage(named: "WelcomeScreenBackground")?.scalePreservingAspectRatio(targetSize: CGSize(width: (bounds.width * 2), height: (bounds.width * 2)))
        let imageView = UIImageView(image: backgroundImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-SemiBold", size: 24)
        label.textColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1)  //#DCE0FF
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Help your baby fall asleep faster and sleep more soundly"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor =  #colorLiteral(red: 0.3529411765, green: 0.4196078431, blue: 0.9333333333, alpha: 1) //#5A6BEE
        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1) //#DCE0FF
        button.layer.cornerRadius = 17
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setGUISettings()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func startButtonTapped(sender: UIButton) {
        sender.isEnabled = false
        let onboardingVC = OnboardingViewController()
        show(onboardingVC, sender: nil)
    }
    
    private func setGUISettings() {
        view.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.06274509804, blue: 0.2, alpha: 1)  //#0B1033
        view.addSubview(backgroundImageView)
        view.addSubview(label)
        view.addSubview(nextButton)
        setBackgroundSettings()
        setLabelSettings()
        setButtonSettings()
    }
    
    private func setBackgroundSettings() {
        let topPadding = 300.0
        let rightPadding = 300.0
 
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -topPadding)
            .isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightPadding)
            .isActive = true
        
        
    }
    
    private func setLabelSettings() {
        let padding = 19.0
        
        
        label.heightAnchor.constraint(equalToConstant: 99.0)
            .isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding)
            .isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            .isActive = true
        label.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -padding)
            .isActive = true
    }
    
    private func setButtonSettings() {
        let bottomPadding = 45.0
        
        
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
            .isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 56.0)
            .isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomPadding)
            .isActive = true
    }
}
