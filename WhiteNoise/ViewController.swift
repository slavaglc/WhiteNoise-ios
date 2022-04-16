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
        view.backgroundColor = UIColor(red: 11 / 255, green: 16 / 255, blue: 51 / 255, alpha: 1)
        
        return view
    }()
    
    override func loadView() {
        view = mainView
    }
}
