//
//  SettingsView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 21.04.2022.
//

import UIKit

class SettingsView: UIView {
    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Nunito-Bold", size: 22)
        view.textColor = .fromNormalRgb(red: 241, green: 233, blue: 255)
        view.text = "Settings"
        
        return view
    }()
    
    private lazy var closeBtn: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "CloseButton")
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var framez: SettingsFrameView = {
        let view = SettingsFrameView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add views
        addSubview(label)
        addSubview(closeBtn)
        addSubview(framez)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func viewDidAppear(_ animated: Bool) {
        viewController?.navigationController?.navigationBar.barStyle = .black
        viewController?.navigationController?.navigationBar.barTintColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        viewController?.navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        
        framez.viewDidAppear(animated)
    }
    
    private func setUpConstraints() {
        // label
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 19),
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -32),
            label.widthAnchor.constraint(equalToConstant: 100),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // closeBtn
        NSLayoutConstraint.activate([
            closeBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            closeBtn.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -32),
            closeBtn.widthAnchor.constraint(equalToConstant: 40),
            closeBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // framez
        NSLayoutConstraint.activate([
            framez.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            framez.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            framez.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            framez.heightAnchor.constraint(equalToConstant: 240),
        ])
    }
    
    @objc
    private func closeView(view: UIView) {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
