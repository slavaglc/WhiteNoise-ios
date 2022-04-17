//
//  ViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 16.04.2022.
//

import UIKit

final class PlansleepViewController: UIViewController {
    private lazy var mainView: UIView = {
        let view = PlansleepView()
        view.backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        
        return view
    }()
    
    override func loadView() {
        viewRespectsSystemMinimumLayoutMargins = false
        view = mainView
    }
}
