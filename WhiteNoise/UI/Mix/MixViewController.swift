//
//  MixViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit

final class MixViewController: UIViewController {
    private lazy var mainView: UIView = {
        let view = MixView()
        view.backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        
        return view
    }()
    
    override func loadView() {
        view = mainView
    }
}
