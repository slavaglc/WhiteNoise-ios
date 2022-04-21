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
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
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
    
    private func setSelectedStyle() {
        gradient.colors = [#colorLiteral(red: 0.5406857133, green: 0.4216250181, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.7745779157, green: 0.7195857167, blue: 1, alpha: 1).cgColor]
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        view.bringSubviewToFront(label)
    }
    
    private func setUnselectedStyle() {
        gradient.colors = [UIColor.clear.cgColor]
    }
}
