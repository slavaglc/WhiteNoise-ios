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
    private lazy var mainView: MixView = {
        let view = MixView(viewController: self)
        view.backgroundColor = .fromNormalRgb(red: 11, green: 16, blue: 51)
        return view
    }()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.getCustomTabBar().isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.getCustomTabBar().isHidden = true
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
