//
//  MyNavigationController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit

final class MyNavigationController: UINavigationController, UINavigationControllerDelegate {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.setHidesBackButton(true, animated: false)
    }
}
