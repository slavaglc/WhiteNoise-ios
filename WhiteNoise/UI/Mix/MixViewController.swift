//
//  MixViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit

protocol MixViewDisplayLogic: AnyObject {
    func addViewToNavgitaionBar(view: UIView)
    func getNavigationController() -> UINavigationController?
    func showSaveMixAlert()
}

final class MixViewController: UIViewController {
    
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
        mainView.setCollectionViewSettings()
        mainView.setCustomBarAppearence()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.setCollectionViewSettings()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.getCustomTabBar().isHidden = true
        navigationController?.navigationBar.isHidden = false
    }
    
    private func saveMix(button: UIButton, alertController: AdvancedAlertViewController) {
        print("saved")
        alertController.close()
    }
    
    private func denySaving(button: UIButton, alertController: AdvancedAlertViewController) {
        alertController.close()
    }
    
    
}

extension MixViewController: MixViewDisplayLogic {
    func showSaveMixAlert() {
        let elements: [AlertElementType] = [
            .title(text: "Name your mix"),
            .textField(placeholder: "Name"),
            .button(title: "Deny", action: denySaving(button:alertController:)),
            .button(title: "Apply", action: saveMix(button:alertController:))
        ]
        let advancedAlertVC = AdvancedAlertViewController(elements: elements)
        present(advancedAlertVC, animated: false)
    }
    
    func getNavigationController() -> UINavigationController? {
        navigationController
    }
    
    func addViewToNavgitaionBar(view: UIView) {
        navigationController?.navigationBar.addSubview(view)
    }
    
}
