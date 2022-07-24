//
//  SettingsView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 21.04.2022.
//

//import StoreKit
import UIKit

final class SettingsView: CustomUIView {
    
    let items = SettingType.AppSettings.allCases
    
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
        view.image = UIImage(named: "close_button_icon_hd")
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var settingsFrame: SettingsFrameView = {
        let view = SettingsFrameView(settingsView: self)
//        view.isHidden = true //temporary
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.register(SettingItemCell.self, forCellReuseIdentifier: SettingItemCell.nameOfClass)
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    //    let items = [
    //        "SettingsContactUs", "SettingsInviteFriend", "SettingsPrivacyPolicy",
    //        "SettingsRateUs", "SettingsSetReminder"
    //    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add views
        addSubview(closeBtn)
        addSubview(label)
        addSubview(settingsFrame)
        addSubview(tableView)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        removeAllViewsFromNavigation()
        
        //        viewController?.navigationController?.navigationBar.barStyle = .black
        //        viewController?.navigationController?.navigationBar.barTintColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        //        viewController?.navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        
        settingsFrame.viewDidAppear(animated)
    }
    
    private func setUpConstraints() {
        // closeBtn
        NSLayoutConstraint.activate([
            closeBtn.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            closeBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeBtn.widthAnchor.constraint(equalToConstant: 40),
            closeBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // label
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: closeBtn.centerYAnchor),
            label.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 19),
            label.widthAnchor.constraint(equalToConstant: 100),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // settingsFrame
        NSLayoutConstraint.activate([
            settingsFrame.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            settingsFrame.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            settingsFrame.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            settingsFrame.heightAnchor.constraint(equalToConstant: 240),
        ])
        
        // tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: settingsFrame.bottomAnchor, constant: 32), //добавить после того, как внедрим подписку
//            tableView.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 16.0), // Временно
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func closeView(view: UIView) {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    private func itemSelected(setting: SettingType.AppSettings) {
        switch setting {
        case .contactUs:
            var components = URLComponents(string: "slava9611@gmail.com")
            components?.queryItems = [URLQueryItem(name: "subject", value: "Subject about WhiteNoise app")]
            components?.scheme = "mailto"
            if let mailUrl = components?.url {
                
                UIApplication.shared.open(mailUrl, options: [:], completionHandler: nil)
            }
        case .inviteFriend:
            presentShareSheet()
        case .privacyPolicy:
            viewController?.navigationController?.pushViewController(PrivacyViewController(), animated: true)
        case .rateUs:
            presentRatingWindow()
        case .setReminder:
            viewController?.navigationController?.pushViewController(PlansleepViewController(), animated: true)
        }
    }
    
    func subButtonClick() {
        viewController?.navigationController?.pushViewController(PaywallViewController(), animated: true)
    }
    
    private func presentShareSheet() {
        guard let appURL = URL(string: "https://apps.apple.com/ru/app/white-point-noise/id1634811540") else { return }
        let activityVC = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = tableView
        activityVC.popoverPresentationController?.sourceRect = tableView.frame
        viewController?.present(activityVC, animated: true)
        
    }
    
    private func presentRatingWindow() {
        let elements: [AlertElementType] = [
            .title(text: "Rate us"),
            .label(text: "Would you like to share your rating for the application?"),
            .button(title: "No", action: cancelAction(button:alert:)),
            .button(title: "Yes", action: presentRequestReview(button:alert:))
        ]
        viewController?.showAdvancedAlert(elements)
    }
    
    private func presentRequestReview(button: UIButton, alert: AdvancedAlertViewController) {
//        guard let scene = window?.windowScene else { return }
//        SKStoreReviewController.requestReview(in: scene)
        guard let url = URL(string: "https://apps.apple.com/app/white-point-noise/id1634811540?action=write-review") else {alert.close(); return}
        UIApplication.shared.open(url)
    
        alert.close()
    }
    
    private func cancelAction(button: UIButton, alert: AdvancedAlertViewController) {
        alert.close()
    }
    
}

extension SettingsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemCell.nameOfClass)! as? SettingItemCell else { return UITableViewCell() }
        let item = items[indexPath.row]
        cell.updateCell(imageName: item.rawValue)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
}

extension SettingsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemSelected(setting: items[indexPath.row])
    }
}
