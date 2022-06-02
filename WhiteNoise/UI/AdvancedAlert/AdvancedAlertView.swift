//
//  AdvancedAlertView.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 02.06.2022.
//

import UIKit



enum AlertElementType {
    case title(text: String)
    case image(imageName: String)
    case label(text: String)
    case textField(placeholder: String)
    case closeButton
    case button(title: String, action: ()->())
}

final class AdvancedAlertView: UIScrollView {

    public var textField: UITextField?
    public var elements: [AlertElementType]?
    
    private weak var advancedAlertVC: AdvancedAlertViewController?
    
    lazy var alertBackground: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.3254901961, alpha: 1) //        #161D53
        view.layer.cornerRadius = 23
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    convenience init(viewController: AdvancedAlertViewController, elements: [AlertElementType]? = nil) {
        self.init()
        advancedAlertVC = viewController
        self.elements = elements
        setPrimarySettings()
        setupConstraints()
    }
    
//    MARK: - Layout
    private func setPrimarySettings() {
//        backgroundColor = .white
        setBlurEffect()
        setupElements()
        addSubview(alertBackground)
        alertBackground.addSubview(buttonsStackView)
    }
    
    private func setupConstraints() {
        let alertHeight = 250.0
        let buttonsStackViewHeight = 30.0
        alertBackground.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
        alertBackground.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        alertBackground.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            .isActive = true
        alertBackground.heightAnchor.constraint(equalToConstant: alertHeight)
            .isActive = true
        
        buttonsStackView.widthAnchor.constraint(equalTo: alertBackground.widthAnchor, multiplier: 0.9)
            .isActive = true
        buttonsStackView.heightAnchor.constraint(equalToConstant: buttonsStackViewHeight)
            .isActive = true
        buttonsStackView.centerXAnchor.constraint(equalTo: alertBackground.centerXAnchor)
            .isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: alertBackground.bottomAnchor, constant: -10)
            .isActive = true
        
    }
    
    private func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.1)
        
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
    
    private func setupElements() {
        guard let elements = elements else { return }
        elements.forEach { element in
            switch element {
            case .title(text: let text):
                break
            case .image(imageName: let imageName):
                break
            case .label(text: let text):
                break
            case .textField(placeholder: let placeholder):
                break
            case .closeButton:
                break
            case .button(title: let title, action: let action):
                let spacerView =  UIView()
                spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
                buttonsStackView.addArrangedSubview(spacerView)
                buttonsStackView.addArrangedSubview(getButton(withTitle: title))
            }
            
        }
    }
    
    private func getButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        
        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1) //#DCE0FF
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito", size: 25)
//        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

}
