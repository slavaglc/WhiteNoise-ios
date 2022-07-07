//
//  TimerViewController.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 06.07.2022.
//

import UIKit

final class TimerViewController: UIViewController {

    private lazy var timerView = TimerView(viewController: self)
    
    override func loadView() {
        view = timerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timerView.didLayoutSubviews()
    }
    
    public func closeDisplay() {
        navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
