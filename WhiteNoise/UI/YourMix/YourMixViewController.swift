//
//  YourMixViewController.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 27.05.2022.
//

import UIKit


final class YourMixViewController: UIViewController {

    var sounds = Array<Sound>()
    private lazy var yourMixView: YourMixView = YourMixView(viewController: self)
    
    convenience init(sounds: [Sound]) {
        self.init()
        self.sounds = sounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        view = yourMixView
    }
    
}
