//
//  ViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 16.04.2022.
//

import UIKit

class ViewController: UIViewController {
    private let mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainView
        view.backgroundColor = .systemBackground
    }

}

class MainView: UIView {
    
}
