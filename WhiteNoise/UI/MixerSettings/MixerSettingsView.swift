//
//  MixerSettings.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 16.07.2022.
//

import UIKit



final class MixerSettingsView: UIView {

    let items = SettingType.MixerSetting.allCases
    
    private var mixModel: MixModel?
    
    private weak var mixerSettingsVC: MixerSettingsViewController?
    
    
    
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nunito", size: 24)
        label.textColor = .white
        label.text = "Your mix"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "close_button_icon_hd"))
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeDisplay))
        imageView.addGestureRecognizer(tap)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingItemCell.self, forCellReuseIdentifier: SettingItemCell.nameOfClass)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionIndexBackgroundColor = .purple
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    convenience init(viewController: MixerSettingsViewController, mixModel: MixModel?) {
        self.init()
        mixerSettingsVC = viewController
        self.mixModel = mixModel
        setPrimarySettings()
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeDisplay() {
        mixerSettingsVC?.closeDisplay()
    }
    
    private func itemSelected(setting: SettingType.MixerSetting) {
        switch setting {
        case .renameMix:
            showRenamingAlert()
        case .deleteMix:
            showConfirmDeletingAlert()
        }
    }
    
    private func deleteCurrentMix(button: UIButton, alertVC: AdvancedAlertViewController) {
        alertVC.close()
        mixerSettingsVC?.closeDisplay()
        mixerSettingsVC?.deleteSelectedMix()
    }
    
    private func cancelAction(button: UIButton, alertVC: AdvancedAlertViewController) {
        alertVC.close()
    }
    
    private func renameMix(button: UIButton, alertVC: AdvancedAlertViewController) {
        guard let newName = alertVC.advancedAlertView.textFields.last?.text, let mixModel = mixModel else { alertVC.close(); return }
        DatabaseManager.shared.renameMix(for: mixModel, to: newName)
        titleLabel.text = newName
        alertVC.close()
    }
    
    private func alertTextFieldValueChanged(textField: UITextField, alertController: AdvancedAlertViewController) {
        guard let text = textField.text else { return }
            let doneButton = alertController.advancedAlertView.buttons.last
        doneButton?.isEnabled = !text.isEmpty
    }
    
    private func showKeyboardInAlert(alertController: AdvancedAlertViewController) {
        let textField = alertController.advancedAlertView.textFields.last
        textField?.becomeFirstResponder()
    }
    
    private func showConfirmDeletingAlert() {
        let mixName = mixModel?.name
        let elements: [AlertElementType] = [
            .title(text: "Delete \(mixName ?? "mix")"),
            .label(text: "Are your sure?"),
            .button(title: "No", action: cancelAction(button:alertVC:)),
            .button(title: "Yes", action: deleteCurrentMix(button:alertVC:))
        ]
        mixerSettingsVC?.showAdvancedAlert(elements)
    }
    
    private func showRenamingAlert() {
        let mixName = mixModel?.name ?? ""
        let elements: [AlertElementType] = [
            .title(text: "Rename \(mixName)"),
            .textField(placeholder: "New name", text: mixName, changedValueAction: alertTextFieldValueChanged(textField:alertController:)),
            .button(title: "Cancel", action: cancelAction(button:alertVC:)),
            .button(title: "Done", action: renameMix(button:alertVC:)),
            .didAppearAction(action: showKeyboardInAlert(alertController:))
        ]
        mixerSettingsVC?.showAdvancedAlert(elements)
    }
    
    private func setPrimarySettings() {
        backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        
        titleLabel.text = mixModel?.name
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(closeButton)
        addSubview(headerStackView)
        addSubview(settingsTableView)
    }
    
    private func setupConstraints() {
        let horizontalBarHeight: CGFloat = 45
        let padding = 16.0
        
        headerStackView.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        headerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5)
            .isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            .isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
            .isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        
        settingsTableView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: 0.8)
            .isActive = true
        settingsTableView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: padding)
            .isActive = true
        settingsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding)
            .isActive = true
    }
    
}

extension MixerSettingsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemCell.nameOfClass, for: indexPath) as? SettingItemCell else { return UITableViewCell() }
        cell.updateCell(imageName: items[indexPath.row].rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemSelected(setting: items[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
