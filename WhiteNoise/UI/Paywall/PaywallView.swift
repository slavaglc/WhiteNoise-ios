//
//  PaywallView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 19.04.2022.
//

import UIKit

class PaywallView: UIView {
    private enum SubSelect {
        case YEAR
        case MONTH
    }
    
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .fromNormalRgb(red: 90, green: 107, blue: 255)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.setTitleColor(UIColor.fromNormalRgb(red: 220, green: 224, blue: 224), for: .normal)
        view.setTitle("Try Free & Subscribe", for: .normal)
        view.titleLabel?.font = UIFont(name: "Nunito-Bold", size: 22)
        
        return view
    }()
    
    private lazy var sub1Button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .fromNormalRgb(red: 201, green: 162, blue: 241)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.setTitleColor(UIColor.fromNormalRgb(red: 15, green: 20, blue: 60), for: .normal)
        view.setTitle("     Yearly - 3 Day Trial Free\n     10$ / Year", for: .normal)
        view.titleLabel?.numberOfLines = 2
        view.contentHorizontalAlignment = .left
        view.titleLabel?.font = UIFont(name: "Nunito-Medium", size: 14)
        view.tag = 0
        view.addTarget(self, action: #selector(selectSub), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var sub2Button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .fromNormalRgb(red: 201, green: 162, blue: 241)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.setTitleColor(UIColor.fromNormalRgb(red: 15, green: 20, blue: 60), for: .normal)
        view.setTitle("     Monthly\n     2$ / Month", for: .normal)
        view.titleLabel?.numberOfLines = 2
        view.contentHorizontalAlignment = .left
        view.titleLabel?.font = UIFont(name: "Nunito-Medium", size: 14)
        view.tag = 1
        view.addTarget(self, action: #selector(selectSub), for: .touchUpInside)
        
        return view
    }()
    
    private var subSelect: SubSelect = SubSelect.YEAR {
        didSet {
            if(subSelect == SubSelect.YEAR) {
                sub2Button.setTitleColor(UIColor.fromNormalRgb(red: 162, green: 171, blue: 241), for: .normal)
                sub2Button.layer.borderWidth = 1
                sub2Button.layer.borderColor = UIColor.fromNormalRgb(red: 162, green: 171, blue: 241).cgColor
                sub2Button.backgroundColor = .clear
                
                UIView.animate(withDuration: 0.3) {
                    self.sub1Button.setTitleColor(UIColor.fromNormalRgb(red: 15, green: 20, blue: 60), for: .normal)
                    self.sub1Button.layer.borderWidth = 0
                    self.sub1Button.layer.borderColor = UIColor.clear.cgColor
                    self.sub1Button.backgroundColor = UIColor.fromNormalRgb(red: 201, green: 162, blue: 241)
                }
            } else {
                sub1Button.setTitleColor(UIColor.fromNormalRgb(red: 162, green: 171, blue: 241), for: .normal)
                sub1Button.layer.borderWidth = 1
                sub1Button.layer.borderColor = UIColor.fromNormalRgb(red: 162, green: 171, blue: 241).cgColor
                sub1Button.backgroundColor = .clear
                
                UIView.animate(withDuration: 0.3) {
                    self.sub2Button.setTitleColor(UIColor.fromNormalRgb(red: 15, green: 20, blue: 60), for: .normal)
                    self.sub2Button.layer.borderWidth = 0
                    self.sub2Button.layer.borderColor = UIColor.clear.cgColor
                    self.sub2Button.backgroundColor = UIColor.fromNormalRgb(red: 201, green: 162, blue: 241)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add views
        addSubview(backgroundImage)
        addSubview(textImage)
        addSubview(subButton)
        addSubview(sub1Button)
        addSubview(sub2Button)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func viewDidAppear(_ animated: Bool) {
        viewController?.navigationController?.view.addSubview(closeBtn)
        viewController?.navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        
        setUpConstraints()
        
        subSelect = SubSelect.YEAR
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
            subButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            subButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16),
            subButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // sub2Button
        NSLayoutConstraint.activate([
            sub2Button.bottomAnchor.constraint(equalTo: subButton.topAnchor, constant: -16),
            sub2Button.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            sub2Button.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16),
            sub2Button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // sub1Button
        NSLayoutConstraint.activate([
            sub1Button.bottomAnchor.constraint(equalTo: sub2Button.topAnchor, constant: -12),
            sub1Button.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            sub1Button.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16),
            sub1Button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func closeView(view: UIView) {
        viewController?.navigationController?.popToRootViewController(animated: true)
        closeBtn.removeFromSuperview()
    }
    
    @objc
    private func selectSub(view: UIButton) {
        if view.tag == 0 { // year
            subSelect = SubSelect.YEAR
        } else if view.tag == 1 { // month
            subSelect = SubSelect.MONTH
        }
    }
}
