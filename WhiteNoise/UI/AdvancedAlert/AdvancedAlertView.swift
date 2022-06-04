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
    case button(title: String, action: (_ button: UIButton, _ alertController: AdvancedAlertViewController)->())
}

final class AdvancedAlertView: UIScrollView {

    public var textField: UITextField?
    public var elements: [AlertElementType]?
    public var beforeCloseAction = {}
   
    private weak var advancedAlertVC: AdvancedAlertViewController?
    
    lazy var alertBackground: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.3254901961, alpha: 1) //#161D53
        view.layer.cornerRadius = 23
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 50
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
//        stackView.backgroundColor = .green
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var closeButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "CloseButtonAlert"))
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeDisplay))
        imageView.addGestureRecognizer(tap)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.alpha = 0.8
        imageView.isHidden = true
        return imageView
    }()
    
    
    convenience init(viewController: AdvancedAlertViewController, elements: [AlertElementType]? = nil) {
        self.init()
        advancedAlertVC = viewController
        self.elements = elements
        setPrimarySettings()
        setupConstraints()
    }
//  MARK: - Actions
   
    public func close() {
        closeDisplay()
    }
    
    @objc private func closeDisplay() {
        fadeOut()
        alertBackground.fadeOutToLeftSide(withOpaque: true) { [weak self] in
            self?.advancedAlertVC?.dismiss(animated: false)
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = contentInset
        contentInset.bottom = keyboardFrame.size.height + alertBackground.frame.height
        print("keyboard height:", keyboardFrame.size.height)
        print("alertBackground height:", alertBackground.frame.height)
        self.contentInset = contentInset
        contentSize = self.frame.size
//        setContentOffset(CGPoint(x: 0, y: keyboardFrame.size.height), animated: true)
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.contentInset = contentInset
    }
    
    
//    MARK: - Layout
    private func setPrimarySettings() {
        delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        setBlurEffect()
        setupElements()
        addSubview(alertBackground)
        alertBackground.addSubview(titleStackView)
        alertBackground.addSubview(closeButton)
        alertBackground.addSubview(contentStackView)
        alertBackground.addSubview(buttonsStackView)
    }
    
    private func setupConstraints() {
        let alertHeight = 100.0
        let buttonsStackViewHeight = 30.0
        let padding = 15.0
        let contentPadding = 20.0
        let closeButtonSize = 45.0
        alertBackground.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
//        alertBackground.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 600)
//            .isActive = true
        alertBackground.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        alertBackground.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            .isActive = true
        alertBackground.heightAnchor.constraint(greaterThanOrEqualToConstant: alertHeight)
            .isActive = true
        
        
        
//        titleStackView.widthAnchor.constraint(equalTo: alertBackground.widthAnchor, multiplier: 0.9)
//            .isActive = true
//        titleStackView.heightAnchor.constraint(equalToConstant: buttonsStackViewHeight)
//            .isActive = true
        titleStackView.topAnchor.constraint(equalTo: alertBackground.topAnchor, constant: padding)
            .isActive = true
        titleStackView.leadingAnchor.constraint(equalTo: alertBackground.leadingAnchor, constant: padding)
            .isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -padding)
            .isActive = true
        titleStackView.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
            .isActive = true
        
        contentStackView.widthAnchor.constraint(equalTo: alertBackground.widthAnchor, multiplier: 0.9)
            .isActive = true
        contentStackView.centerXAnchor.constraint(equalTo: alertBackground.centerXAnchor)
            .isActive = true
        contentStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: contentPadding)
            .isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -contentPadding * 3)
            .isActive = true
        
        closeButton.trailingAnchor.constraint(equalTo: alertBackground.trailingAnchor, constant: -padding)
            .isActive = true
        closeButton.topAnchor.constraint(equalTo: alertBackground.topAnchor, constant: padding)
            .isActive = true
        
        closeButton.widthAnchor.constraint(equalToConstant: closeButtonSize)
            .isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: closeButtonSize)
            .isActive = true
        
        
        buttonsStackView.widthAnchor.constraint(equalTo: alertBackground.widthAnchor, multiplier: 0.9)
            .isActive = true
        buttonsStackView.heightAnchor.constraint(equalToConstant: buttonsStackViewHeight)
            .isActive = true
        buttonsStackView.centerXAnchor.constraint(equalTo: alertBackground.centerXAnchor)
            .isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: alertBackground.bottomAnchor, constant: -padding)
            .isActive = true
        
    }
    
    private func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.1)
        
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
    
    private func setupElements() {
        let spacerView =  UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        buttonsStackView.addArrangedSubview(spacerView)
        
        guard let elements = elements else { return }
        elements.forEach { element in
            switch element {
            case .title(text: let text):
                titleStackView.addArrangedSubview(getLabel(text: text))
            case .image(imageName: let imageName):
                contentStackView.addArrangedSubview(getImageView(imageName: imageName))
            case .label(text: let text):
                contentStackView.addArrangedSubview(getLabel(text: text))
            case .textField(placeholder: let placeholder):
                contentStackView.addArrangedSubview(getTextField(placeholder: placeholder))
            case .closeButton:
                closeButton.isHidden = false
            case .button(title: let title, action: let action):
                buttonsStackView.addArrangedSubview(getButton(withTitle: title, withAction: action))
            }
        }
    }
    
    private func getButton(withTitle title: String, withAction passedAction: @escaping (_ button: UIButton, _ alertController: AdvancedAlertViewController)->() = {button , advancedAlertVC in }) -> UIButton {
        let action = UIAction { [weak self] action in
            if let sender = action.sender as? UIButton {
                passedAction(sender, (self?.advancedAlertVC)!)
            }
        }
        let button = UIButton(type: .system, primaryAction: action)
        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1) //#DCE0FF
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito", size: 25)
//        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func getLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-Bold", size: 18)
        label.textColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)  //#A2ABF1
        label.text = text
        return label
    }
    
    private func getTextField(placeholder: String) -> AdvancedTextField {
        let textField = AdvancedTextField(borderStyle: .bottom(borderColor: #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)))//#A2ABF1
        textField.delegate = self
        textField.placeholder = placeholder
        textField.placeholderColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1) //#A2ABF1
        textField.textColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1) //#DCE0FF
        textField.font = UIFont(name: "Nunito-Bold", size: 18)
        textField.autocorrectionType = .no
        textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
            .isActive = true
        return textField
    }
    
    private func getImageView(imageName: String) -> UIImageView {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        return imageView
    }

}

extension AdvancedAlertView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        setContentOffset(CGPoint(x: 0, y: 300), animated: true)
        return true
    }
}

extension AdvancedAlertView: UIScrollViewDelegate {
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        false
    }
}
