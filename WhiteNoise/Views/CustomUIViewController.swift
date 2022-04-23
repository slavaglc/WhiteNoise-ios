//
//  CustomUIViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 23.04.2022.
//

import UIKit

class CustomUIViewController: UIViewController {
    private func getCustomView() -> CustomUIView? {
        return view as? CustomUIView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if view != nil {
            getCustomView()?.viewDidAppear(animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if view != nil {
            getCustomView()?.viewDidLoad()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if view != nil {
            getCustomView()?.viewDidDisappear(animated)
        }
    }
}
