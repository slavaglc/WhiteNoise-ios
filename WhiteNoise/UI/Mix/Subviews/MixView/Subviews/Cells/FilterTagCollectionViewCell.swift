//
//  FilterTagCollectionViewCell.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 21.04.2022.
//

import UIKit

final class FilterTagCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setSelectedStyle()
            } else {
                setUnselectedStyle()
            }
        }
    }
    
    
    private lazy var gradient = CAGradientLayer()
    
    private lazy var view: UIView = {
        let view = UIView()
        view.layer.borderColor =  #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1).cgColor //#A2ABF1
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-Bold", size: 18)
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    public func setCellParameters(filterTag: FilterTag) {
        label.text = filterTag.title
    }
    
    private  func initialize() {
        view.addSubview(label)
        addSubview(view)
        setupContraints()
    }
    
    private func setupContraints() {
        view.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        view.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor)
            .isActive = true
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
        
    }
    
    func setSelectedStyle() {
        gradient.colors = [#colorLiteral(red: 0.7882352941, green: 0.6352941176, blue: 0.9450980392, alpha: 1).cgColor, #colorLiteral(red: 0.4549019608, green: 0.2196078431, blue: 0.9568627451, alpha: 1).cgColor] //#C9A2F1 #7438F4
        gradient.frame = view.frame
        gradient.bounds = view.bounds
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        view.layer.borderColor = UIColor.clear.cgColor
      
        self.view.layer.addSublayer(gradient)
        self.view.bringSubviewToFront(label)
        
        
    }
    
    private func setUnselectedStyle() {
        gradient.colors = [UIColor.clear.cgColor]
        view.layer.borderColor = #colorLiteral(red: 0.6352941176, green: 0.6705882353, blue: 0.9450980392, alpha: 1).cgColor //#A2ABF1
    }
}
