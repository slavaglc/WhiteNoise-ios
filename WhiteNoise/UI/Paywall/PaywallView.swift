//
//  PaywallView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 19.04.2022.
//

import UIKit

class PaywallView: UIView {
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "PaywallBackground")
        
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
    
    private lazy var textImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "PaywallText")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private lazy var subButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .fromNormalRgb(red: 90, green: 107, blue: 255)
        //view.layer.cornerRadius = 16
        //view.clipsToBounds = true
        //view.setTitleColor(UIColor.fromNormalRgb(red: 220, green: 224, blue: 224), for: .normal)
        view.setTitle("Try Free & Subscribe", for: .normal)
        //view.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 22)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add views
        addSubview(backgroundImage)
        addSubview(textImage)
        addSubview(subButton)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func viewDidAppear(_ animated: Bool) {
        viewController?.navigationController?.view.addSubview(closeBtn)
        viewController?.navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        // backgroundImage
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // closeBtn
        NSLayoutConstraint.activate([
            closeBtn.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -32),
            closeBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeBtn.widthAnchor.constraint(equalToConstant: 40),
            closeBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // textImage
        NSLayoutConstraint.activate([
            textImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 64),
            textImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            textImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
        
        // subButton
        NSLayoutConstraint.activate([
            subButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            subButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            subButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: -16),
            subButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func closeView(view: UIView) {
        viewController?.navigationController?.popToRootViewController(animated: true)
        closeBtn.removeFromSuperview()
    }
}
