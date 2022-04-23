//
//  MixView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit


final class MixView: UIView {
    
    private enum ViewState: String {
        case Create, Saved
    }
    
    private let filterTags = FilterTag.getAllFilterTags()
    private let sounds = Sound.getAllSounds()
    
    private weak var mixViewDisplayLogic: MixViewDisplayLogic!
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var upgradeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "Lock")
        button.setTitle(" Upgrate", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito", size: 16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundImage(for: .normal)
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.7058823529, blue: 1, alpha: 1)
            .withAlphaComponent(0.1)
        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Gear")
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.7058823529, blue: 1, alpha: 1)
            .withAlphaComponent(0.1)
        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var filterTagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FilterTagCollectionViewCell.self, forCellWithReuseIdentifier: FilterTagCollectionViewCell.nameOfClass)
        
        return collectionView
    }()
    
    private lazy var soundsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(SoundCollectionViewCell.self, forCellWithReuseIdentifier: SoundCollectionViewCell.nameOfClass)
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private lazy var segmentControl: CustomSegmentedControl = {
        let titles = [ViewState.Create.rawValue,
                      ViewState.Saved.rawValue
        ]
        let control = CustomSegmentedControl(frame: CGRect.zero, buttonTitle: titles)
        
        return control
    }()
    
    private lazy var customTabBar: CustomTabBar = {
        let customTabBar = CustomTabBar()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        return customTabBar
    }()
    
    convenience init(viewController: MixViewDisplayLogic) {
        self.init()
        mixViewDisplayLogic = viewController
        setPrimarySettings()
    }
    
    public func getCustomTabBar() -> CustomTabBar {
        customTabBar
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customTabBar.halfFadeOut()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customTabBar.halfFadeIn()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        customTabBar.halfFadeOut()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        customTabBar.halfFadeIn()
    }
    
    @objc
    private func buttonClicked(button: UIButton) {
//        settingsButton.removeFromSuperview()
//        upgradeButton.removeFromSuperview()
            
        if button.tag == 0 {
            viewController?.navigationController?.pushViewController(SettingsViewController(), animated: true)
        }
    }
    
    
    @objc private func segmentDidChange(_ segmentControl: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
    
    private func setPrimarySettings() {
        horizontalStackView.addArrangedSubview(upgradeButton)
        horizontalStackView.addArrangedSubview(settingsButton)
//        stackView.addArrangedSubview(horizontalStackView)
//        mixViewDisplayLogic.addViewToNavgitaionBar(view: horizontalStackView)
        stackView.addArrangedSubview(horizontalStackView)
        stackView.setCustomSpacing(25, after: horizontalStackView)
        stackView.addArrangedSubview(segmentControl)
        stackView.addArrangedSubview(filterTagCollectionView)
        stackView.addArrangedSubview(soundsCollectionView)
        addSubview(stackView)
        setCustomTabBarSettings()
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        let spacing = UIScreen.main.bounds.size.width / 2
        let horizontalBarHeight: CGFloat = 50
        let upgrateButtonWidth = 100.0
        let padding = 10.0
        
        horizontalStackView.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        settingsButton.heightAnchor.constraint(equalTo: settingsButton.widthAnchor)
            .isActive = true
        upgradeButton.widthAnchor.constraint(equalToConstant: upgrateButtonWidth)
            .isActive = true
        
        stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        stackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding)
            .isActive = true
        

        horizontalStackView.setCustomSpacing(spacing, after: upgradeButton)
        upgradeButton.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor)
            .isActive = true
        settingsButton.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor)
            .isActive = true
        settingsButton.widthAnchor.constraint(equalTo: settingsButton.heightAnchor)
            .isActive = true
        
        segmentControl.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
            .isActive = true

        segmentControl.widthAnchor.constraint(equalTo: stackView.widthAnchor)
            .isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        
        filterTagCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        filterTagCollectionView.heightAnchor.constraint(equalTo: segmentControl.heightAnchor, multiplier: 2).isActive = true
        soundsCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        
    }
    
    private func setCustomTabBarSettings() {
        guard let navigationController = mixViewDisplayLogic.getNavigationController() else { return }
        navigationController.view.addSubview(customTabBar)
        customTabBar.widthAnchor.constraint(equalTo: navigationController.view.widthAnchor, multiplier: 0.65)
            .isActive = true
        customTabBar.heightAnchor.constraint(equalToConstant: 70)
            .isActive = true
        customTabBar.centerXAnchor.constraint(equalTo: navigationController.view.centerXAnchor)
            .isActive = true
        customTabBar.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor, constant: -50)
            .isActive = true
    }
}

// MARK: - CollectionView methods

extension MixView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == soundsCollectionView ? sounds.count : filterTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            
        case soundsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundCollectionViewCell.nameOfClass, for: indexPath) as? SoundCollectionViewCell else { return UICollectionViewCell() }
            cell.setCellParameters(sound: sounds[indexPath.item])
            return cell
        case filterTagCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterTagCollectionViewCell.nameOfClass, for: indexPath) as? FilterTagCollectionViewCell else { return UICollectionViewCell() }
                cell.setCellParameters(filterTag: filterTags[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case soundsCollectionView:
            let height = (24.552 * 1.5 ) + 100 + 10 // 24.552 is font height of label
            return CGSize(width: 100, height: height)
        case filterTagCollectionView:
            return CGSize(width: 100, height: 50)
        default:
            return CGSize(width: 100, height: 100)
        }
    }
}


