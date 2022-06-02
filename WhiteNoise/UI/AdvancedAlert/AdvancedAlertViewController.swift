//
//  AdvancedAlertViewController.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 02.06.2022.
//

import UIKit


final class AdvancedAlertViewController: UIViewController {

    
    public var elements: [AlertElementType]?
    private lazy var advancedAlertView = AdvancedAlertView(viewController: self, elements: elements)
    
    
    convenience init(elements: [AlertElementType]? = nil) {
        self.init()
        self.elements = elements
    }
    
    override func loadView() {
        view = advancedAlertView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        advancedAlertView.alpha = 1
        advancedAlertView.alertBackground.fadeInFromLeftSide()
    }

}
