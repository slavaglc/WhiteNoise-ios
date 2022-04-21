//
//  MixViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit

protocol MixViewDisplayLogic: AnyObject {
    func addViewToNavgitaionBar(view: UIView)
    func getNavigationController() -> UINavigationController?
}

final class MixViewController: UIViewController {
    private lazy var mainView: UIView = {
        let view = MixView(viewController: self)
        view.backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        return view
    }()
    
    override func loadView() {
        view = mainView
    }
}

extension MixViewController: MixViewDisplayLogic {
    func getNavigationController() -> UINavigationController? {
        navigationController
    }
    
    func addViewToNavgitaionBar(view: UIView) {
        navigationController?.navigationBar.addSubview(view)
    }
    
}
