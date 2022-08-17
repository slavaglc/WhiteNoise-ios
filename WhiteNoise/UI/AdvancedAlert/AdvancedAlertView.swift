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
    case textField(placeholder: String, text: String = "",
                   changedValueAction: (_ textField: UITextField, _ advancedAlertVC: AdvancedAlertViewController)->() = {_,_ in },
                   beginEditingAction: (_ textField: UITextField, _ advancedAlertVC: AdvancedAlertViewController)->() = {_,_ in },
                   endEditingAction: (_ textField: UITextField, _ advancedAlertVC: AdvancedAlertViewController)->() = {_,_ in }
                    )
    case closeButton
    case button(title: String, action: (_ button: UIButton, _ alertController: AdvancedAlertViewController)->())
    case backgroundImage(image: UIImage, topPadding: CGFloat, bottomPadding: CGFloat, leftPadding: CGFloat, rightPadding: CGFloat)
    case sound(sound: Sound)
    case spacer(height: CGFloat)
    case action(action: (_ alertController: AdvancedAlertViewController)->())
    case willSetupAction(action: (_ alertController: AdvancedAlertViewController)->())
    case didSetupAction(action: (_ alertController: AdvancedAlertViewController)->())
    case didAppearAction(action: (_ alertController: AdvancedAlertViewController)->())
}

final class AdvancedAlertView: UIScrollView {
//   MARK: - Properties
    public var textField: UITextField?
    public var elements: [AlertElementType]?
    public var beforeCloseAction = {}
    public var textFields = Array<UITextField>()
    public var buttons = Array<UIButton>()
    public var closeAction: () -> () = {}
    private var beginEditingTFActions = Array<(_ textField: UITextField, _ alertController: AdvancedAlertViewController)->()>()
    private var endEditingTFActions = Array<(_ textField: UITextField, _ alertController: AdvancedAlertViewController)->()>()
    private var changedValueTFActions = Array<(_ textField: UITextField, _ alertController: AdvancedAlertViewController)->()>()
    
    private weak var advancedAlertVC: AdvancedAlertViewController?
    
    
    
//    MARK: - UI-Elements
    
    let spacerView =  UIView()
    
    lazy var alertBackground: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.3254901961, alpha: 1) //#161D53
        view.layer.cornerRadius = 23
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
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
//        stackView.alignment = .
        stackView.alignment = .center
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
    
    public func didAppear() {
        elements?.forEach{ element in
            if case .didAppearAction(action: let action) = element {
                guard let advancedAlertVC = advancedAlertVC else { return }
                action(advancedAlertVC)
            }
        }
    }
        
    
    public func close() {
        closeDisplay()
    }
    
    @objc private func closeDisplay() {
        fadeOut()
        alertBackground.fadeOutToLeftSide(withOpaque: true) { [weak self] in
            self?.advancedAlertVC?.dismiss(animated: false, completion: {
                self?.closeAction()
            })
        }
    }
    
    @objc private func textFieldValueChanged(textField: UITextField) {
        guard let advancedAlertVC = advancedAlertVC else { return }
        guard changedValueTFActions.indices.contains(textField.tag) else { return }
        changedValueTFActions[textField.tag](textField, advancedAlertVC)
    }
    
    @objc private func keyboardWillShow(notification:NSNotification){
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = contentInset
        contentInset.bottom = keyboardFrame.size.height + alertBackground.frame.height
        self.contentInset = contentInset
        contentSize = self.frame.size
    }

    @objc private func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.contentInset = contentInset
    }
    
    private func performWillSetupAction() {
        elements?.forEach { element in
            if case .willSetupAction(let action) = element {
                guard let advancedAlertVC = advancedAlertVC else { return }
                action(advancedAlertVC)
            }
        }
    }
    
    private func performDidSetupAction() {
        elements?.forEach { element in
            if case .didSetupAction(let action) = element {
                guard let advancedAlertVC = advancedAlertVC else { return }
                action(advancedAlertVC)
            }
        }
    }
    
    
//    MARK: - Layout
    
    public func layoutAfterAppearence() {
        layoutButtonTitles()
    }
    
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
    
    private func setupConstraints(for soundView: UIView) {
        
    }
    
    private func layoutButtonTitles() {
        buttons.forEach { button in
            if buttonIsMinimized(button: button) {
                buttonsStackView.removeArrangedSubview(spacerView)
                buttons.first?.contentHorizontalAlignment = .leading
            }
        }
    }
    
    private func buttonIsMinimized(button: UIButton) -> Bool {
        button.intrinsicContentSize.width > button.bounds.width
    }
    
    private func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.1)
        
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: .zero)
    }
    
    ///Arranges UI-elements
    private func setupElements() {
        performWillSetupAction()
        
        guard let elements = elements else { return }
        elements.forEach { element in
            switch element {
            case .title(text: let text):
                titleStackView.addArrangedSubview(getTitleLabel(text: text))
            case .image(imageName: let imageName):
                contentStackView.addArrangedSubview(getImageView(imageName: imageName))
            case .label(text: let text):
                contentStackView.addArrangedSubview(getLabel(text: text))
            case .textField(placeholder: let placeholder, text: let text, changedValueAction: let changedValueAction, beginEditingAction: let beginEditingAction, endEditingAction: let endEditingAction):
                let textField = getTextField(placeholder: placeholder, text: text, beginEditingAction: beginEditingAction, endEditingAction: endEditingAction, changedValueTFAction: changedValueAction)
                contentStackView.addArrangedSubview(textField)
                textField.widthAnchor.constraint(equalTo: contentStackView.widthAnchor)
                    .isActive = true
                
            case .spacer(height: let height):
                contentStackView.addArrangedSubview(getSpacer(height: height))
            case .closeButton:
                closeButton.isHidden = false
            case .button(title: let title, action: let action):
                buttonsStackView.addArrangedSubview(getButton(withTitle: title, withAction: action))
            case .backgroundImage(image: let image, topPadding: let top, bottomPadding: let bottom, leftPadding: let left, rightPadding: let right):
                setBackgroundImage(image: image, topPadding: top, bottomPadding: bottom, leftPadding: left, rightPadding: right)
            case .sound(sound: let sound):
                let soundView = getSoundView(sound: sound)
                contentStackView.addArrangedSubview(soundView)
            case .action(action: let action):
                guard let advancedAlertVC = advancedAlertVC else { break }
                action(advancedAlertVC)
            default:
                break
            }
        }
        
        buttonsStackView.insertArrangedSubview(spacerView, at: .zero)
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        performDidSetupAction()
    }
    
    
//    MARK: - Creating UIElements
    private func getButton(withTitle title: String, withAction passedAction: @escaping (_ button: UIButton, _ alertController: AdvancedAlertViewController)->() = {button , advancedAlertVC in }) -> UIButton {
        let action = UIAction { [weak self] action in
            if let sender = action.sender as? UIButton {
                passedAction(sender, (self?.advancedAlertVC)!)
            }
        }
        let button = UIButton(type: .system, primaryAction: action)
        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1) //#DCE0FF
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito", size: 21)
        buttons.append(button)
        button.tag = buttons.count - 1
//        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func getTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-Bold", size: 18)
        label.textColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)  //#A2ABF1
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    private func getLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-Regular", size: 17)
        label.textColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1)  //#DCE0FF
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    private func getSpacer(height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        spacer.heightAnchor.constraint(equalToConstant: height)
            .isActive = true
        spacer.translatesAutoresizingMaskIntoConstraints = false
        return spacer
    }
    
    
    
    private func getTextField(placeholder: String, text: String, beginEditingAction:        @escaping
                              (_ textField: UITextField, _ alertController: AdvancedAlertViewController)->() = {_,_ in },
                              endEditingAction:
        @escaping
                              (_ textField: UITextField, _ alertController: AdvancedAlertViewController)->() = {_,_ in },
                              changedValueTFAction:
        @escaping
                              (_ textField: UITextField, _ alertController: AdvancedAlertViewController)->() = {_,_ in }
    ) -> AdvancedTextField {
        let textField = AdvancedTextField(borderStyle: .bottom(borderColor: #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1)))//#A2ABF1
        textField.delegate = self
        textField.placeholder = placeholder
        textField.text = text
        textField.placeholderColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1) //#A2ABF1
        textField.textColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1) //#DCE0FF
        textField.font = UIFont(name: "Nunito-Bold", size: 18)
        textField.autocorrectionType = .no
        textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
            .isActive = true
        textField.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .editingChanged)
        textFields.append(textField)
        textField.tag = textFields.count - 1
        beginEditingTFActions.append(beginEditingAction)
        endEditingTFActions.append(endEditingAction)
        changedValueTFActions.append(changedValueTFAction)
        
        return textField
    }
    
    private func getImageView(imageName: String) -> UIImageView {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            .isActive = true
        return imageView
    }
    ///Sets background image for alert
    private func setBackgroundImage(image: UIImage, topPadding: CGFloat, bottomPadding: CGFloat, leftPadding: CGFloat, rightPadding: CGFloat) {
        let imageView = UIImageView(image: image)
        
//        alertBackground.addSubview(imageView)
        alertBackground.insertSubview(imageView, at: .zero)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        alertBackground.clipsToBounds = true
        
        imageView.bottomAnchor.constraint(equalTo: alertBackground.bottomAnchor, constant: bottomPadding)
            .isActive = true
        imageView.leadingAnchor.constraint(equalTo: alertBackground.leadingAnchor, constant: leftPadding)
            .isActive = true
        imageView.trailingAnchor.constraint(equalTo: alertBackground.trailingAnchor, constant: rightPadding)
            .isActive = true
        imageView.topAnchor.constraint(equalTo: alertBackground.topAnchor, constant: topPadding)
            .isActive = true

        
        
    }
    
    private func getSoundView(sound: Sound) -> SoundView {
        let soundView = SoundView(sound: sound, sideOfSquare: 98)
        soundView.translatesAutoresizingMaskIntoConstraints = false
        return soundView
    }
    

}

//MARK: - Extensions

extension AdvancedAlertView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        setContentOffset(CGPoint(x: 0, y: 300), animated: true)
        true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let advancedAlertVC = advancedAlertVC else { return }
        guard !beginEditingTFActions.isEmpty else { return }
        beginEditingTFActions[textField.tag](textField, advancedAlertVC)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let advancedAlertVC = advancedAlertVC else { return }
        guard !endEditingTFActions.isEmpty else { return }
        endEditingTFActions[textField.tag](textField, advancedAlertVC)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength: Int8 = 35
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.count <= maxLength
    }
}

extension AdvancedAlertView: UIScrollViewDelegate {
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        false
    }
}

extension AdvancedAlertView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer.isEnabled = false
        return true
    }
}
