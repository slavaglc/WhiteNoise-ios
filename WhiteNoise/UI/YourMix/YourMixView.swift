//
//  YourMix.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 27.05.2022.
//

import UIKit


final class YourMixView: UIView {

    
    private let sounds = Sound.getAllSounds()
    
    private weak var yourMixViewController: YourMixViewController?
    
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
        let imageView = UIImageView(image: UIImage(named: "CloseButton"))
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeDisplay))
        imageView.addGestureRecognizer(tap)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var mixesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(YourMixTableViewCell.self, forCellReuseIdentifier: YourMixTableViewCell.nameOfClass)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 150
        return tableView
    }()
    
    private lazy var bottomMenu: BottomMenu = {
        let bottomMenu = BottomMenu()
        bottomMenu.translatesAutoresizingMaskIntoConstraints = false
        return bottomMenu
    }()
    
    convenience init(viewController: YourMixViewController) {
        self.init()
        self.yourMixViewController = viewController
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPrimarySettings()
        setupConstraints()
    }
    
    @objc private func closeDisplay() {
        yourMixViewController?.navigationController?.popViewController(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPrimarySettings() {
        backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(closeButton)
        addSubview(headerStackView)
        addSubview(mixesTableView)
        addSubview(bottomMenu)
    }
    
    private func setupConstraints() {
        let horizontalBarHeight: CGFloat = 45
        let padding = 16.0

        
        headerStackView.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        headerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            .isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            .isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
            .isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        
        
        mixesTableView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10)
            .isActive = true
        mixesTableView.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        mixesTableView.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        mixesTableView.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
            .isActive = true
        
        
        bottomMenu.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        bottomMenu.heightAnchor.constraint(equalToConstant: 80)
            .isActive = true
        bottomMenu.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        bottomMenu.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            .isActive = true
    }
}


extension YourMixView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YourMixTableViewCell.nameOfClass, for: indexPath) as? YourMixTableViewCell else { return UITableViewCell() }
        cell.setCellParameters(sound: sounds[indexPath.row])
        return cell
    }
}
