//
//  MixViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit
import GoogleMobileAds

let adMobBannerKey = "ca-app-pub-4375579747830843/5801878367"

protocol MixViewDisplayLogic: AnyObject {
    func getNavigationController() -> UINavigationController?
    func showSaveMixAlert()
    func showPaywallVC()
    func setNumberForBadge(number: Int)
    func halfFadeOutTabBar()
    func halfFadeInTabBar()
    func showAlertForLockedSound(sound: Sound, for indexPath: IndexPath?)
}

final class MixViewController: UIViewController {
    private var rewardedAd: GADRewardedAd?
    
    private enum ViewState: String, CaseIterable {
        case create = "Create", saved = "Saved"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var viewState = ViewState.create {
        didSet {
            setSelectedView(viewState: viewState)
        }
    }
    
    private var didLayout = false
    
    private lazy var pages = Array<UIView>()
    
    private var isFirstLaunch = true
    
    private lazy var mainView: MixView = {
        let view = MixView(displayLogic: self)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var savedMixesView: SavedMixesView = {
        let view = SavedMixesView(displayLogic: self)
        view.isHidden = false
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var customTabBar: CustomTabBar = {
        let customTabBar = CustomTabBar()
        customTabBar.layer.cornerRadius = 23
        customTabBar.layer.shadowRadius = 2
        customTabBar.layer.shadowColor = UIColor.black.cgColor
        customTabBar.layer.shadowOpacity = 0.3
        customTabBar.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        return customTabBar
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //    private lazy var upgradeButton: UIButton = {
    //        let button = UIButton(type: .system)
    //        let image = UIImage(named: "lock_icon_hd")
    //        button.setTitle(" Upgrate", for: .normal)
    //        button.titleLabel?.font = UIFont(name: "Nunito-Semibold", size: 14)
    //        button.titleLabel?.adjustsFontSizeToFitWidth = true
    //        button.tintColor = .white
    //        button.setImage(image, for: .normal)
    //        button.layer.cornerRadius = 23
    //        button.backgroundImage(for: .normal)
    //        button.clipsToBounds = true
    //        button.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.7058823529, blue: 1, alpha: 1)
    //            .withAlphaComponent(0.1)
    //        button.tintColor = #colorLiteral(red: 0.862745098, green: 0.8784313725, blue: 1, alpha: 1)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.addTarget(self, action: #selector(upgrateButtonTapped), for: .touchUpInside)
    //        return button
    //    }()
    
    private lazy var upgradeButton: UIImageView = {
        let image = UIImage(named: "UpgradeButton")
        let imageView = UIImageView(image: image)
        let tap = UITapGestureRecognizer(target: self, action: #selector(upgrateButtonTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var settingsButton: UIImageView = {
        let image = UIImage(named: "settings_icon_hd")
        let imageView = UIImageView(image: image)
        let tap = UITapGestureRecognizer(target: self, action: #selector(settingsButtonTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
//    private lazy var banner: GADBannerView = {
//        let banner = GADBannerView()
//        banner.adUnitID = adMobBannerKey
//        banner.load(gADRequest)
//        banner.backgroundColor = .orange
//        return banner
//    }()
    
    private var lockedSound: Sound?
    private var lockedSoundIndexPath: IndexPath?
    
    override func loadView() {
        super.loadView()
        setPrimarySettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.removeAllViewsFromNavigation()
        navigationController?.navigationBar.isHidden = true
        mainView.refreshSelectedSoundsData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didLayout {
            let height = customTabBar.frame.height
            let bottomPadding = 20.0
            mainView.setSoundsCollectionViewBottomInset(height + bottomPadding)
            didLayout = true
        }
        
        //banner.frame = view.frame
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLaunch {
            mainView.setCollectionViewSettings()
            //            mainView.refreshData()
            isFirstLaunch = false
        }
        mainView.refreshSelectedSoundsData()
        savedMixesView.refreshData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
        //banner.rootViewController = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    @objc
    private func settingsButtonTapped() {
        show(SettingsViewController(), sender: nil)
    }
    
    @objc private func upgrateButtonTapped() {
        showPaywallVC()
    }
    
    
    private func setSelectedView(viewState: ViewState) {
        guard let index = ViewState.allCases.firstIndex(of: viewState) else { return }
        let currentPageCGFloat = CGFloat(index)
        let screenPoint = UIScreen.main.bounds.width
        let pointY = scrollView.bounds.minY
        scrollView.setContentOffset(CGPoint(x: (screenPoint * currentPageCGFloat), y: pointY), animated: true)
    }
    
    private func setPrimarySettings() {
        view.backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        
        headerStackView.addArrangedSubview(upgradeButton)
        headerStackView.addArrangedSubview(settingsButton)
        view.addSubview(headerStackView)
        view.addSubview(segmentControl)
        view.addSubview(scrollView)
        
        setCustomTabBarSettings()
        setScrollViewSettings()
        setupConstraints()
        setActions()
    }
    
    private func setScrollViewSettings() {
        scrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(segmentControl.segmentsCount)
        
        pages.append(mainView)
        pages.append(savedMixesView)
        
        
        for (index, page) in pages.enumerated() {
            page.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(page)
            page.widthAnchor.constraint(equalTo: view.widthAnchor)
                .isActive = true
            page.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
                .isActive = true
            
            
            if index == .zero {
                page.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor)
                    .isActive = true
            } else {
                page.leadingAnchor.constraint(equalTo: pages[index-1].trailingAnchor)
                    .isActive = true
            }
        }
    }
    
    private func setCustomTabBarSettings() {
        let height = 70.0
        let bottomPadding = 50.0
        
        view.addSubview(customTabBar)
        customTabBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65)
            .isActive = true
        
        customTabBar.heightAnchor.constraint(equalToConstant: height)
            .isActive = true
        customTabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
        customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomPadding)
            .isActive = true
        //        setSoundsCollectionViewBottomInset(height+bottomPadding)
    }
    
    private func setupConstraints() {
        let spacing = 176.0
        let horizontalBarHeight: CGFloat = 45
        let padding = 16.0
        let upgrateButtonWidth = 112.0
        
        headerStackView.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
            .isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding)
            .isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            .isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
        segmentControl.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 36)
            .isActive = true
        segmentControl.widthAnchor.constraint(equalTo: view.widthAnchor)
            .isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: horizontalBarHeight)
            .isActive = true
        
        scrollView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: padding)
            .isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            .isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
            .isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
    }
    
    
    //MARK: - Custom TabBar Actions
    private func playButtonTapped() {
        customTabBar.togglePlaybackState()
    }
    
    private func mixerButtonTapped() {
        show(YourMixViewController(sounds: mainView.playingSounds), sender: nil)
    }
    
    private func saveMixTapped() {
        showSaveMixAlert()
    }
    
    private func setTimerButtonTapped() {
        let timerVC = TimerViewController()
        show(timerVC, sender: nil)
    }
    
    private func setActions() {
        customTabBar.setAction(for: .play, action: playButtonTapped)
        customTabBar.setAction(for: .mixer, action: mixerButtonTapped)
        customTabBar.setAction(for: .saveMix, action: saveMixTapped)
        customTabBar.setAction(for: .timer, action: setTimerButtonTapped)
    }
    
    private func saveMix(button: UIButton, alertController: AdvancedAlertViewController) {
        guard let name = alertController.advancedAlertView.textFields.first?.text else { return }
        let sounds = mainView.playingSounds
        DatabaseManager.shared.save(mixName: name, sounds: sounds) { success, error in
            if success {
                savedMixesView.refreshData()
                alertController.close()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        alertController.close()
    }
    //    MARK: - Alert Actions
    private func denySaving(button: UIButton, alertController: AdvancedAlertViewController) {
        alertController.close()
    }
    
    private func showKeyboardInAlert(alertController: AdvancedAlertViewController) {
        let textField = alertController.advancedAlertView.textFields.last
        textField?.becomeFirstResponder()
    }
    
    private func loadAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: adMobBannerKey,
                           request: request,
                           completionHandler: { [self] ad, error in
          if let error = error {
            print("[AD] Failed to load rewarded ad with error: \(error.localizedDescription)")

            return
          }
          rewardedAd = ad
            print("[AD] Rewarded ad loaded")
        }
        )
    }
    
    private func watchAd(button: UIButton, alertController: AdvancedAlertViewController) {
        if let lockedSoundIndexPath = lockedSoundIndexPath {
            if let ad = rewardedAd {
                let elements: [AlertElementType] = [
                    .closeButton,
                    .label(text: "Waiting ad..."),
                ]
                
                // MARK: todo alertController.close()
                alertController.showAdvancedAlert(elements)
                
                print("[AD] Try ad present")
                ad.present(fromRootViewController: self) {
                    let reward = ad.adReward
                    print("[AD] Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                    
                    // reward the user
                    self.lockedSound?.isLocked = false
                    self.mainView.refreshSoundData(for: lockedSoundIndexPath)
                }
            } else {
                print("[AD] Ad not loaded")
                guard let image = UIImage(named: "GiftImage") else { return }
                let elements: [AlertElementType] = [
                    .closeButton,
                    .spacer(height: 150),
                    .backgroundImage(image: image, topPadding: 66, bottomPadding: 64, leftPadding: 13, rightPadding: -60),
                ]
                // MARK: todo alertController.close()
                alertController.showAdvancedAlert(elements)
            }
        }
    }
    
    private func unlockAllSounds(button: UIButton, alertController: AdvancedAlertViewController) {
        alertController.close()
        show(PaywallViewController(), sender: nil)
    }
    
    private func showCongratulationsAlert() {
        guard let image = UIImage(named: "GiftImage") else { return }
        let elements: [AlertElementType] = [
            .closeButton,
            .backgroundImage(image: image, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0)
        ]
        showAdvancedAlert(elements)
    }
    
    
}

extension MixViewController: MixViewDisplayLogic {
    
    func showAlertForLockedSound(sound: Sound, for indexPath: IndexPath? = nil) {
        lockedSound = sound
        lockedSoundIndexPath = indexPath
        let elements: [AlertElementType] = [
            .title(text: "To unlock the sound you can"),
            .sound(sound: sound),
            .label(text: "Watch a short video to get this sound or get a premium and unlock all sounds"),
            .closeButton,
            .button(title: "Unlock all sounds", action: unlockAllSounds(button:alertController:)),
            .button(title: "Watch ad", action: watchAd(button:alertController:))
        ]
        showAdvancedAlert(elements)
    }
    
    func halfFadeInTabBar() {
        customTabBar.halfFadeIn()
    }
    
    func halfFadeOutTabBar() {
        customTabBar.halfFadeOut()
    }
    
    func setNumberForBadge(number: Int) {
        customTabBar.setNumberForBadge(number: number)
    }
    
    func showPaywallVC() {
        let paywallVC = PaywallViewController()
        show(paywallVC, sender: nil)
    }
    
    func showSaveMixAlert() {
        let elements: [AlertElementType] = [
            .title(text: "Name your mix"),
            .textField(placeholder: "Name"),
            .button(title: "Deny", action: denySaving(button:alertController:)),
            .button(title: "Apply", action: saveMix(button:alertController:)),
            .didAppearAction(action: showKeyboardInAlert(alertController:))
        ]
        showAdvancedAlert(elements)
    }
    
    func getNavigationController() -> UINavigationController? {
        navigationController
    }
    
}

extension MixViewController: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        viewState = index == 0 ? .create : .saved
    }
}

extension MixViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            setCurrentPage()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setCurrentPage()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setCurrentPage(animated: true)
    }
    
    func setCurrentPage(animated: Bool = false) {
        let width = UIScreen.main.bounds.width
        let currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(width)))
        segmentControl.setIndex(index: currentPage, animated: animated)
    }
}
