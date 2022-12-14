//
//  PaywallViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 19.04.2022.
//

import UIKit


final class PaywallViewController: UIViewController {
    private lazy var paywallView: PaywallView = {
        let view = PaywallView(isFirstLaunch: isFirstLaunch)
        view.backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        
        return view
    }()
    
    private var isFirstLaunch = false
    
    convenience init(isFirstLaunch: Bool = false) {
        self.init()
        self.isFirstLaunch = isFirstLaunch
    }
    override func loadView() {
        view = paywallView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        paywallView.willAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        paywallView.didAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
