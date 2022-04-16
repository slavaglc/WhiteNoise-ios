//
//  ViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 16.04.2022.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var mainView: UIView = {
        let view = MainView()
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    override func loadView() {
        view = mainView
    }
}
