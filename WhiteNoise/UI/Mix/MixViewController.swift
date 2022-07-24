//
//  MixViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit

protocol MixViewDisplayLogic: AnyObject {
    func getNavigationController() -> UINavigationController?
    func showSaveMixAlert()
    func showPaywallVC()
}

final class MixViewController: UIViewController {
    
    private var isFirstLaunch = true
    
    private lazy var mainView: MixView = {
        let view = MixView(viewController: self)
        view.backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.removeAllViewsFromNavigation()
        mainView.getCustomTabBar().isHidden = false
        navigationController?.navigationBar.isHidden = true
//        mainView.setCollectionViewSettings()
        mainView.setCustomBarAppearence()
        mainView.refreshSoundsData()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLaunch {
            mainView.setCollectionViewSettings()
//            mainView.refreshData()
            isFirstLaunch = false
        }
        mainView.refreshSavedMixData()
        mainView.refreshUIElements()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.getCustomTabBar().isHidden = true
        navigationController?.navigationBar.isHidden = false
    }
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    private func saveMix(button: UIButton, alertController: AdvancedAlertViewController) {
        guard let name = alertController.advancedAlertView.textFields.first?.text else { return }
        let sounds = mainView.playingSounds
        DatabaseManager.shared.save(mixName: name, sounds: sounds) { success, error in
            if success {
                mainView.refreshSavedMixData()
                alertController.close()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        alertController.close()
    }
    
    private func denySaving(button: UIButton, alertController: AdvancedAlertViewController) {
        alertController.close()
    }
    
    private func showKeyboardInAlert(alertController: AdvancedAlertViewController) {
        let textField = alertController.advancedAlertView.textFields.last
        textField?.becomeFirstResponder()
    }
    
    
}

extension MixViewController: MixViewDisplayLogic {
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
