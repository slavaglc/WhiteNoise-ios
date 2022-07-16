//
//  UIViewController.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 04.06.2022.
//

import UIKit


extension UIViewController {
    func hideKeyboardOnTouch() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAdvancedAlert(_ elements: [AlertElementType]) {
        let alertVC = AdvancedAlertViewController(elements: elements)
        self.present(alertVC, animated: false)
    }
}
