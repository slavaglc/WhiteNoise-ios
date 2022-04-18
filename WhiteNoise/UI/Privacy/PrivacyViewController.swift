//
//  PrivacyViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 18.04.2022.
//

import UIKit

class PrivacyViewController: UIViewController {
    private lazy var privacyView: PrivacyView = {
        let view = PrivacyView()
        view.backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        
        return view
    }()
    
    override func loadView() {
        view = privacyView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        privacyView.viewDidAppear(animated)
    }
}
