//
//  PaywallViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 19.04.2022.
//

import UIKit


final class PaywallViewController: UIViewController {
    private lazy var paywallView: PaywallView = {
        let view = PaywallView()
        view.backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        
        return view
    }()
    
    override func loadView() {
        view = paywallView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        paywallView.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
