//
//  UIPageIndicatorView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 17.04.2022.
//

import UIKit

class UIPageIndicatorView: UIView {
    private var selectedItem = 0
    
    private lazy var view1: UICircle = {
        let view = UICircle()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .fromNormalRgb(red: 90, green: 107, blue: 238)
        
        return view
    }()
    
    private lazy var view2: UICircle = {
        let view = UICircle()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .fromNormalRgb(red: 90, green: 107, blue: 238)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add views
        addSubview(view1)
        addSubview(view2)
        
        setUpConstrains()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpConstrains() {
        view1.removeConstraints(view1.constraints)
        view2.removeConstraints(view2.constraints)
        
        if selectedItem == 0 {
            // view2
            NSLayoutConstraint.activate([
                view2.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
                view2.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                view2.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                view2.widthAnchor.constraint(equalToConstant: 8)
            ])
            
            // view1
            NSLayoutConstraint.activate([
                view1.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
                view1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                view1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                view1.rightAnchor.constraint(equalTo: view2.leftAnchor, constant: -8)
            ])
        } else {
            // view1
            NSLayoutConstraint.activate([
                view1.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
                view1.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                view1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                view1.widthAnchor.constraint(equalToConstant: 8)
            ])
            
            // view2
            NSLayoutConstraint.activate([
                view2.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
                view2.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                view2.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                view2.leftAnchor.constraint(equalTo: view1.rightAnchor, constant: -8)
            ])
        }
    }
    
    func selectItem(pos: Int) {
        selectedItem = pos
        setUpConstrains()
    }
}
