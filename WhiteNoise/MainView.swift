//
//  MainView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 16.04.2022.
//

import UIKit

final class MainView: UIView {
    private lazy var textView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont(name: "Avenir", size: 16)
        view.text = "Example"
        view.textColor = .black
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpConstraint() {
        // textview
        NSLayoutConstraint.activate([
            textView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            textView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            textView.widthAnchor.constraint(equalToConstant: 200),
            textView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}
