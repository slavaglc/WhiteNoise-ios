//
//  MixView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit


final class MixView: UIView {
    
    private enum ViewState: String {
        case create, saved
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
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var upgradeButton: UIButton = {
        let button = UIButton(type: .system)
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
        button.translatesAutoresizingMaskIntoConstraints = false
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
        let titles = [ViewState.create.rawValue,
                      ViewState.saved.rawValue
        ]
        let control = CustomSegmentedControl(frame: CGRect.zero, buttonTitle: titles)
        
        return control
    }()
    
    convenience init(viewController: MixViewDisplayLogic) {
        self.init()
        mixViewDisplayLogic = viewController
        setPrimarySettings()
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
        stackView.addArrangedSubview(horizontalStackView)
        stackView.addArrangedSubview(segmentControl)
        stackView.addArrangedSubview(filterTagCollectionView)
        stackView.addArrangedSubview(soundsCollectionView)
        addSubview(stackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let spacing = UIScreen.main.bounds.size.width / 2
        let horizontalBarHeight: CGFloat = 50
        let statusBarHeight = (window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 10) * 2
        let topSpacing = statusBarHeight + 10
        stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        stackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.95).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: topSpacing)
            .isActive = true
        
        horizontalStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
            .isActive = true
        horizontalStackView.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
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

//        segmentControl.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
//        segmentControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundCollectionViewCell.nameOfClass, for: indexPath) as? SoundCollectionViewCell else { return CGSize(width: 100, height: 120)}
            let height = (cell.getFontHeight() * 1.5 ) + 100
            return CGSize(width: 100, height: height)
        case filterTagCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterTagCollectionViewCell.nameOfClass, for: indexPath) as? FilterTagCollectionViewCell else { return CGSize(width: 100, height: 50) }
//            cell.setCellParameters(filterTag: filterTags[indexPath.item])
            return CGSize(width: 100, height: 50)
        default:
            return CGSize(width: 100, height: 100)
        }
    }
}


