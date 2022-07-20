//
//  ImageBackgroundView.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 01.05.2022.
//

import UIKit

enum SelectedStyle {
    case selected(animated: Bool, volume: Float), unselected(animated: Bool)
}

final class ImageBackgroundView: UIView, CAAnimationDelegate {
    
    private let gradientLayer = CAGradientLayer()
    private var gradientColorSet: [[CGColor]] = [[#colorLiteral(red: 0.7882352941, green: 0.6352941176, blue: 0.9450980392, alpha: 1).cgColor, #colorLiteral(red: 0.4549019608, green: 0.2196078431, blue: 0.9568627451, alpha: 1).cgColor]]
    private var colorIndex: Int = 0
    private var volume: Float = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    public func setStyle(selectedStyle: SelectedStyle) {
        switch selectedStyle {
        case .selected(let animated, volume: let volume):
            setSelectedStyle(animated: animated, volume: volume)
            break
        case .unselected(let animated):
            setUnselectedStyle(animated: animated)
            break
        }
    }
    
    public func setVolumeState(by location: CGPoint, for volume: inout Float) {
        let width = location.x
        gradientLayer.frame.size.width = width > 0 ? width : 0.1
        volume = Float(width * 0.01)
        self.volume = volume
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.frame
        gradientLayer.frame.size.width *=  CGFloat(volume)
        gradientLayer.bounds = self.bounds
        gradientLayer.bounds.size.width *=  CGFloat(volume)
        gradientLayer.masksToBounds = true
        
    }
    
    private func initialize() {
        backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.3254901961, alpha: 1)
        layer.cornerRadius = 25
        clipsToBounds = true
        
        setGradientSettings()
    }
    
    
    private func setGradientSettings() {
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setSelectedStyle(animated: Bool, volume: Float) {
        self.volume = volume
        gradientLayer.isHidden = false
        layoutSubviews()
        gradientLayer.colors = gradientColorSet.first
//        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.opacity = 1
        gradientLayer.locations = [0.0, 0.7 , 1.0]
//        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.21, b: -1.14, c: 1.14, d: 5.3, tx: -0.66, ty: -1.61))
        guard animated else { return }
        animateGradient()
    }
    
    private func setUnselectedStyle(animated: Bool) {
        guard animated else { gradientLayer.isHidden = true; return }
        gradientLayer.opacity = 0
    }
    
    private func animateGradient() {
        let startGradientColors = [[#colorLiteral(red: 0.4549019608, green: 0.2196078431, blue: 0.9568627451, alpha: 1).cgColor, #colorLiteral(red: 0.7882352941, green: 0.6352941176, blue: 0.9450980392, alpha: 1).cgColor]]
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientLayer.colors = startGradientColors.first
        gradientAnimation.delegate = self
        gradientAnimation.duration = 0.5
        gradientAnimation.toValue = gradientColorSet.first
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        gradientLayer.add(gradientAnimation, forKey: "colors")
    }
}
