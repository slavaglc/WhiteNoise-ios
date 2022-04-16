//
//  ViewController.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 16.04.2022.
//

import UIKit

class ViewController: UIViewController {
    private let mainView = MainView()
    
    override func viewDidLoad() {
        view = mainView
        view.backgroundColor = .systemBackground // set background
        
        super.viewDidLoad()
        mainView.viewDidLoad()
    }

}

class MainView: UIView {
    private let textView = UITextView()
    
    func viewDidLoad() {
        // add textview
        addSubview(textView)
        
        // setup textview
        textView.text = "WhiteNoise"
        textView.textColor = .black
        
        // setup contraint for textview
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.leftAnchor.constraint(equalTo: self.leftAnchor),
            textView.widthAnchor.constraint(equalToConstant: 200),
            textView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
