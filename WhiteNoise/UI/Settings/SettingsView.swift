//
//  SettingsView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 21.04.2022.
//

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
    
    private lazy var framez: SettingsFrameView = {
        let view = SettingsFrameView(settingsView: self)
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
        addSubview(framez)
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
        
        framez.viewDidAppear(animated)
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
        
        // framez
        NSLayoutConstraint.activate([
            framez.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            framez.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            framez.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            framez.heightAnchor.constraint(equalToConstant: 240),
        ])
        
        // tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: framez.bottomAnchor, constant: 32),
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
            var components = URLComponents(string: "youremail@test.com")
            components?.queryItems = [URLQueryItem(name: "subject", value: "Your Subject")]

            if let mailUrl = components?.url {
                UIApplication.shared.open(mailUrl, options: [:], completionHandler: nil)
            }
        case .inviteFriend:
            guard let url = URL(string: "https://google.com") else { return }
            UIApplication.shared.open(url)
        case .privacyPolicy:
            viewController?.navigationController?.pushViewController(PrivacyViewController(), animated: true)
        case .rateUs:
            guard let url = URL(string: "https://google.com") else { return }
            UIApplication.shared.open(url)
        case .setReminder:
            viewController?.navigationController?.pushViewController(PlansleepViewController(), animated: true)
        }
    }
    
    func subButtonClick() {
        viewController?.navigationController?.pushViewController(PaywallViewController(), animated: true)
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
