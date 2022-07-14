//
//  SavedMixTableViewCell.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 18.06.2022.
//

import UIKit


protocol SavedMixTableViewCellDelegate {
    func delete(at cell: SavedMixTableViewCell)
}

final class SavedMixTableViewCell: UITableViewCell {
    
    
    var trackNumber: Int?
    var delegate: SavedMixTableViewCellDelegate?
    
    private lazy var mixBar: MixBar = {
        let mixBar = MixBar()
        mixBar.translatesAutoresizingMaskIntoConstraints = false
        return mixBar
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Nunito", size: 18)
        label.textColor = .white
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setPrimarySettings()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNumber = nil
        mixBar.trackNumber = trackNumber
//        mixBar.removeSoundIcons()
    }
    
    public func refreshCell() {
        mixBar.setSoundsLayout()
    }
    
    
    public func setCellParameters(mix: MixModel, trackNumber: Int) {
        nameLabel.text = mix.name
        self.trackNumber = trackNumber
        let sounds = DatabaseManager.shared.getSounds(from: mix)
        print("sounds for cell:", sounds)
        mixBar.setMixBarParameters(for: sounds)
        mixBar.layoutSubviews()
        mixBar.trackNumber = trackNumber
        mixBar.delegate = self
    }
    
    private func setPrimarySettings() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(mixBar)
        contentView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
       
        let height = 75.0
        let padding = 10.0
        
        mixBar.widthAnchor.constraint(equalTo: widthAnchor)
            .isActive = true
        mixBar.heightAnchor.constraint(equalToConstant: height)
            .isActive = true
        mixBar.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        mixBar.topAnchor.constraint(equalTo: topAnchor)
            .isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: mixBar.bottomAnchor, constant: padding)
            .isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            .isActive = true
    }
    
}

extension SavedMixTableViewCell: MixBarDelegate {
    func deleteMix() {
        delegate?.delete(at: self)
    }
}
