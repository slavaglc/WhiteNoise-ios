//
//  PlansleepViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 16.04.2022.
//

import UIKit

final class PlansleepViewController: UIViewController {
    private lazy var mainView: PlansleepView = {
        let view = PlansleepView()
        view.backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        
        return view
    }()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainView.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
