//
//  MixView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit


final class MixView: UIView {
    
    
    private var volumeIsSelecting = false
    
    private enum ViewState: String {
        case create = "Create", saved = "Saved"
    }
    
    public var playingSounds: [Sound] {
        sounds.filter {$0.isPlaying}
    }
    
    private var viewState = ViewState.create {
        didSet {
            setSelectedView(viewState: viewState)
        }
    }
    
    private var isFirstAppearence = true
//    private let nc = NotificationCenter.default
    private let filterTags = FilterTag.getAllFilterTags()
    private let deviceName = UIDevice.modelName
    private var sounds = Sound.getAllSounds()
    private var filtredSounds = Array<Sound>()
        
    private weak var mixViewDisplayLogic: MixViewDisplayLogic!
    
    
//        MARK: - UI Elements
    
    lazy var customTabBar: CustomTabBar = {
        let customTabBar = CustomTabBar()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        return customTabBar
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var upgradeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "lock_icon_hd")
        button.setTitle(" Upgrate", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-Semibold", size: 14)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 23
        button.backgroundImage(for: .normal)
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.7058823529, blue: 1, alpha: 1)
            .withAlphaComponent(0.1)
        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(upgrateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingsButton: UIImageView = {
        let image = UIImage(named: "settings_icon_hd")
        let imageView = UIImageView(image: image)
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClicked))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
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
        collectionView.contentInset.left = 15
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private lazy var segmentControl: CustomSegmentedControl = {
        let titles = [ViewState.create.rawValue,
                      ViewState.saved.rawValue
        ]
        let control = CustomSegmentedControl(frame: CGRect.zero, buttonTitle: titles)
        control.delegate = self
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var savedMixesView: SavedMixesView = {
        let view = SavedMixesView()
        view.isHidden = viewState == .create ? true : false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    // MARK: - Initialization and lifecycle
    
    convenience init(viewController: MixViewDisplayLogic) {
        self.init()
        mixViewDisplayLogic = viewController
        setPrimarySettings()
    }
    
    public func refreshSoundsData() {
        if let indexPaths = soundsCollectionView.indexPathsForSelectedItems {
        soundsCollectionView.reloadItems(at: indexPaths)
        }
    }
    
    public func refreshSavedMixData() {
        savedMixesView.refreshData(withTabBar: customTabBar)
    }
    
//    @objc private func appMovedToForeground() {
//        print("Returned to foreground...")
//        print("Selected index:", segmentControl.selectedIndex)
////        let segmentIndex = segmentControl.selectedIndex
////        DispatchQueue.main.asyncAfter(deadline: .now()) {
////            self.segmentControl.setIndex(index: segmentIndex)
////        }
//    }
    
    // MARK: - Scroll methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == soundsCollectionView else { return }
        customTabBar.halfFadeOut()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == soundsCollectionView else { return }
        customTabBar.halfFadeIn()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == soundsCollectionView else { return }
        customTabBar.halfFadeOut()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == soundsCollectionView else { return }
        customTabBar.halfFadeIn()
    }
    
    // MARK: - Actions
    
    
    
    public func getCustomTabBar() -> CustomTabBar {
        customTabBar
    }
    
    @objc
    private func swipeHandler(gesture: UISwipeGestureRecognizer) {
        switch gesture.state {
        case .possible:
            break
        case .began:
            break
        case .changed:
            break
        case .ended:
//             viewState = gesture.direction == .left ? .saved : .create
            segmentControl.setIndex(index: gesture.direction == .left ? 1 : .zero)
            change(to: gesture.direction == .left ? 1 : .zero)
            
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
    
    @objc
    private func buttonClicked() {
            viewController?.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc private func upgrateButtonTapped() {
        mixViewDisplayLogic.showPaywallVC()
        upgradeButton.isEnabled = false
    }
    
    private func playButtonTapped() {
        customTabBar.togglePlaybackState()
    }
    
    private func mixerButtonTapped() {
        viewController?.show(YourMixViewController(sounds: playingSounds), sender: nil)
    }
    
    private func saveMixTapped() {
        mixViewDisplayLogic.showSaveMixAlert()
    }
    
    private func setTimerButtonTapped() {
        let timerVC = TimerViewController()
        viewController?.show(timerVC, sender: nil)
    }
    
    private func setSelectedView(viewState: ViewState) {
        switch viewState {
        case .create:
            savedMixesView.isHidden = true
            filterTagCollectionView.isHidden = false
            soundsCollectionView.isHidden = false
        case .saved:
            filterTagCollectionView.isHidden = true
            soundsCollectionView.isHidden = true
            savedMixesView.isHidden = false
            savedMixesView.refreshData(withTabBar: customTabBar)
        }
    }
    
    // MARK: - GUI Settings
    
    public func setCollectionViewSettings() {
        let indexPath = IndexPath(item: .zero, section: .zero)
        collectionView(filterTagCollectionView, didSelectItemAt: indexPath)
        filterTagCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    public func setCollectionViewAppearence() {
        setCollectionViewSettings()
    }
    
    public func setCustomBarAppearence() {
//        customTabBar.playbackState = AudioManager.shared.playbackState
    }
    
    public func setCustomTabBarAppearence() {
        customTabBar.setPlaybackState()
    }
    
    public func refreshUIElements() {
        upgradeButton.isEnabled = true
    }
    
    private func setPrimarySettings() {
//        nc.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        headerStackView.addArrangedSubview(upgradeButton)
        headerStackView.addArrangedSubview(settingsButton)
        addSubview(headerStackView)
        addSubview(segmentControl)
        addSubview(filterTagCollectionView)
        addSubview(soundsCollectionView)
        addSubview(savedMixesView)
        setCustomTabBarSettings()
        setupConstraints()
        setActions()
        setGestureSettings()
    }
    
    private func setGestureSettings() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(gesture:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(gesture:)))
        swipeRight.direction = .right
        addGestureRecognizer(swipeLeft)
        addGestureRecognizer(swipeRight)
    }
    
    private func setActions() {
        customTabBar.setAction(for: .play, action: playButtonTapped)
        customTabBar.setAction(for: .mixer, action: mixerButtonTapped)
        customTabBar.setAction(for: .saveMix, action: saveMixTapped)
        customTabBar.setAction(for: .timer, action: setTimerButtonTapped)
    }
    
    private func setupConstraints() {
//        let spacing = UIScreen.main.bounds.size.width / 4
        let spacing = 176.0
        let horizontalBarHeight: CGFloat = 45
        let padding = 16.0
        let upgrateButtonWidth = 112.0

        headerStackView.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        headerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5)
            .isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            .isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
            .isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true

        

        filterTagCollectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        filterTagCollectionView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        filterTagCollectionView.heightAnchor.constraint(equalTo: segmentControl.heightAnchor, multiplier: 1.5).isActive = true
        filterTagCollectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10)
            .isActive = true
        
        
        
        soundsCollectionView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        soundsCollectionView.topAnchor.constraint(equalTo: filterTagCollectionView.bottomAnchor, constant: 16)
            .isActive = true
        soundsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            .isActive = true
        soundsCollectionView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
            .isActive = true
        
        savedMixesView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9)
            .isActive = true
        savedMixesView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
            .isActive = true
        savedMixesView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10)
            .isActive = true
        savedMixesView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            .isActive = true
        
        
        headerStackView.setCustomSpacing(spacing, after: upgradeButton)
        upgradeButton.heightAnchor.constraint(equalTo: headerStackView.heightAnchor)
            .isActive = true
        settingsButton.heightAnchor.constraint(equalTo: headerStackView.heightAnchor)
            .isActive = true
        settingsButton.widthAnchor.constraint(equalTo: settingsButton.heightAnchor)
            .isActive = true
        upgradeButton.widthAnchor.constraint(equalToConstant: upgrateButtonWidth)
            .isActive = true
        
        segmentControl.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        segmentControl.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 36)
            .isActive = true
        segmentControl.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
    }
    
    private func setCustomTabBarSettings() {
        let height = 70.0
        let bottomPadding = 50.0
        guard let navigationController = mixViewDisplayLogic.getNavigationController() else { return }
        navigationController.view.addSubview(customTabBar)
        customTabBar.widthAnchor.constraint(equalTo: navigationController.view.widthAnchor, multiplier: 0.65)
            .isActive = true
        
        customTabBar.heightAnchor.constraint(equalToConstant: height)
            .isActive = true
        customTabBar.centerXAnchor.constraint(equalTo: navigationController.view.centerXAnchor)
            .isActive = true
        customTabBar.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor, constant: -bottomPadding)
            .isActive = true
        setSoundsCollectionViewBottomInset(height+bottomPadding)
    }
    
    private func setSoundsCollectionViewBottomInset(_ inset: CGFloat) {
        soundsCollectionView.contentInset.bottom = inset * 1.5
    }
}

// MARK: - CollectionView methods

extension MixView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == soundsCollectionView ? filtredSounds.count : filterTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            
        case soundsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundCollectionViewCell.nameOfClass, for: indexPath) as? SoundCollectionViewCell else { return UICollectionViewCell() }
            cell.contentView.isHidden = true
            let sound = filtredSounds[indexPath.item]
            cell.delegate = self
            cell.setCellParameters(sound: sound)
            if sound.isPlaying {
                soundsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                cell.setBackgroundStyle(selectedStyle: .selected(animated: false, volume: sound.volume))
            }
            customTabBar.setNumberForBadge(number: playingSounds.count)
            cell.contentView.fadeIn(duration: 0.4, completionAnimation: {})
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
        let height = (24.552 * 1.5 ) + 100 + 10 // 24.552 is font height of label
        let heightForSound = (deviceName == "iPod9,1" || deviceName == "Simulator iPod touch (7th generation)") ? (24.552 * 1.5 ) + 70 + 10 : height
        let widthForSound = (deviceName == "iPod9,1" || deviceName == "Simulator iPod touch (7th generation)") ? 70.0 : 100.0
        switch collectionView {
        case soundsCollectionView:
            return CGSize(width: widthForSound, height: heightForSound)
        case filterTagCollectionView:
            return CGSize(width: 100, height: 50)
        default:
            return CGSize(width: 100, height: 100)
        }
    }
    
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case filterTagCollectionView:
            let selectedTag = filterTags[indexPath.row].title
            guard let cell = filterTagCollectionView.cellForItem(at: indexPath) as? FilterTagCollectionViewCell else { return }
            cell.setSelectedStyle()
            filtredSounds = selectedTag != "All" ? sounds.filter { $0.category == selectedTag } : sounds
            soundsCollectionView.reloadData()
            break
        case soundsCollectionView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? SoundCollectionViewCell else { return }
            guard !filtredSounds[indexPath.item].isLocked else { collectionView.deselectItem(at: indexPath, animated: true)
                return }
            let sound = filtredSounds[indexPath.item]
            cell.isUserInteractionEnabled = false
            AudioManager.shared.pauseAllSounds(.saved)
            AudioManager.shared.changeViewsState(to: .pause, mixType: .saved)
            AudioManager.shared.changePlaybackState(to: .play, mixType: .current)
            AudioManager.shared.prepareToPlay(sound: sound, mixType: .current) {
                cell.isUserInteractionEnabled = true
            }
            cell.setBackgroundStyle(selectedStyle: .selected(animated: true, volume: sound.volume))
            break
        default:
            return
        }
        customTabBar.setNumberForBadge(number: playingSounds.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case soundsCollectionView:
            guard let cell = collectionView.cellForItem(at: indexPath) as? SoundCollectionViewCell else { return }
            guard !filtredSounds[indexPath.item].isLocked else { return }
//            filtredSounds[indexPath.item].isPlaying = false
            cell.isUserInteractionEnabled = false
            let sound = filtredSounds[indexPath.item]
            sound.isPlaying = false
            AudioManager.shared.stopPlayback(sound: sound) {
                cell.isUserInteractionEnabled = true
            }
            cell.setBackgroundStyle(selectedStyle: .unselected(animated: true))
        default:
            return
        }
        customTabBar.setNumberForBadge(number: playingSounds.count)
    }
    
}
// MARK: - Custom Segment Control Methods
extension MixView: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        
        switch index {
        case 0:
            viewState = .create
        case 1:
            viewState = .saved
        default:
            break
        }
    }
}

// MARK: - SoundCollectionViewCell Methods
extension MixView: SoundCollectionViewCellDelegate {
    func selectingVolumeBegan(in cell: SoundCollectionViewCell) {
        guard let indexPath = soundsCollectionView.indexPath(for: cell) else { return }
        collectionView(soundsCollectionView, didSelectItemAt: indexPath)
        soundsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
    }
    
    func selectingVolumeEnded(in cell: SoundCollectionViewCell) {
        guard let indexPath = soundsCollectionView.indexPath(for: cell) else { return }
        collectionView(soundsCollectionView, didDeselectItemAt: indexPath)
        soundsCollectionView.deselectItem(at: indexPath, animated: true)
    }
}
