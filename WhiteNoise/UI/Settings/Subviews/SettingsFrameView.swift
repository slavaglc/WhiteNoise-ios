//
//  SettingsFrameView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 21.04.2022.
//

import UIKit


final class SettingsFrameView: UIView {
    private lazy var background: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "SettingsFrame")
        
        return view
    }()
    
    private lazy var moon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Cloud")
        view.contentMode = .center
        
        return view
    }()
    
    private lazy var label1: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Nunito-Bold", size: 16)
        view.textColor = .fromNormalRgb(red: 241, green: 233, blue: 255)
        view.text = "Baby don`t sleep?"
        
        return view
    }()
    
    private lazy var label2: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Nunito-Bold", size: 16)
        view.textColor = .fromNormalRgb(red: 241, green: 233, blue: 255)
        view.text = "Try all sounds"
        
        return view
    }()
    
    private lazy var text1: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "FrameText2")
        view.contentMode = .center
        
        return view
    }()
    
    private lazy var text2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "FrameText1")
        view.contentMode = .center
        
        return view
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton(type: .system)
        view.tag = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Try Free & Subscribe", for: .normal)
        view.setTitleColor(.fromNormalRgb(red: 220, green: 224, blue: 255), for: .normal)
        view.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 18)
        view.backgroundColor = .fromNormalRgb(red: 90, green: 107, blue: 238)
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(subButtonClick), for: .touchUpInside)
        
        return view
    }()
    
    private let settingsView: SettingsView
    
    init(settingsView: SettingsView) {
        self.settingsView = settingsView
        
        super.init(frame: CGRect())
        
        // configure border
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.fromNormalRgb(red: 220, green: 224, blue: 255).cgColor
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        
        // add views
        addSubview(background)
        addSubview(moon)
        addSubview(label1)
        addSubview(label2)
        addSubview(text1)
        addSubview(text2)
        addSubview(button)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.settingsView = SettingsView()
        super.init(coder: coder)
    }
    
    func setUpConstraints() {
        // background
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            background.topAnchor.constraint(equalTo: self.topAnchor),
            background.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // moon
        NSLayoutConstraint.activate([
            moon.topAnchor.constraint(equalTo: background.topAnchor, constant: -16),
            moon.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            moon.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -16)
        ])
        
        // label1
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: background.topAnchor, constant: -32),
            label1.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            label1.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 16)
        ])
        
        // label2
        NSLayoutConstraint.activate([
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: -64),
            label2.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            label2.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 16)
        ])
        
        // text1
        NSLayoutConstraint.activate([
            text1.topAnchor.constraint(equalTo: background.bottomAnchor, constant: 16),
            text1.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 16)
        ])
        
        // text2
        NSLayoutConstraint.activate([
            text2.topAnchor.constraint(equalTo: text1.bottomAnchor, constant: 8),
            text2.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 16)
        ])
        
        // button
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            button.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc
    private func subButtonClick(button: UIButton) {
        settingsView.subButtonClick()
    }
}
