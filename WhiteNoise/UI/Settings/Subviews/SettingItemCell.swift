//
//  SettingItemCell.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 22.04.2022.
//

import UIKit


final class SettingItemCell: UITableViewCell {
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .left
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(self.image)
        setSelectionStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateCell(imageName: String) {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.topAnchor),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            image.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        image.image = UIImage(named: imageName)
    }
    
    private func setSelectionStyle() {
        let selectionColor = UIView() as UIView
        selectionColor.backgroundColor = UIColor.fromNormalRgb(red: 22, green: 29, blue: 83)
        selectedBackgroundView = selectionColor
    }
}
