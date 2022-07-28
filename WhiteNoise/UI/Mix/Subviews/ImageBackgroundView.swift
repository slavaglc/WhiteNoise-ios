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

final class ImageBackgroundView: UIView {
    
    private enum PositionAnimationType {
        case forward, back
    }
    
    public var withVolumeControl: Bool = false
    private let gradientLayer = CAGradientLayer()
    private var gradientColorSet: [[CGColor]] = [[#colorLiteral(red: 0.7882352941, green: 0.6352941176, blue: 0.9450980392, alpha: 1).cgColor, #colorLiteral(red: 0.4549019608, green: 0.2196078431, blue: 0.9568627451, alpha: 1).cgColor]]
    private var colorIndex: Int = 0
    private var volume: Float = 0.0
    
    
    
    private lazy var volumeDamper: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    
    convenience init(withVolumeControl: Bool = false) {
        self.init()
        self.withVolumeControl = withVolumeControl
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
        setVolumeDamperPosition()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        switch anim.value(forKey: "bounds") as? String {
        case "back":
            setVolumeDamperPosition()
        default:
            break
        }
    }
    
    private func initialize() {
        if withVolumeControl { addSubview(volumeDamper) }
        backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.3254901961, alpha: 1)
        volumeDamper.backgroundColor = backgroundColor
        layer.cornerRadius = 25
        clipsToBounds = true
        setGradientSettings()
    }
    
    
    private func setGradientSettings() {
        gradientLayer.position.x = .zero
        gradientLayer.anchorPoint.x = .zero
        self.layer.insertSublayer(gradientLayer, at: .zero)
    }
    
    private func setSelectedStyle(animated: Bool, volume: Float) {
        volumeDamper.alpha = 1
        self.volume = volume
        gradientLayer.isHidden = false
        layoutSubviews()
        gradientLayer.colors = gradientColorSet.first
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.opacity = 1
        gradientLayer.locations = [0.0, 0.7 , 1.0]
        guard gestureRecognizers?.first?.state != .began else { return }
        guard animated else { return }
        animateVolumeDamperPosition()
        animateGradient()
    }
    
    private func setUnselectedStyle(animated: Bool) {
        guard animated else { gradientLayer.isHidden = true; return }
        gradientLayer.opacity = 0
        animateVolumeDamperDissapear()
    }
    
    private func animateVolumeDamperDissapear() {
        UIView.animate(withDuration: 0.3) {
            self.volumeDamper.frame.origin.x = self.frame.minX
        } completion: { isFinished in
            if isFinished {
                
            }
        }
    }
    
    private func animateVolumeDamperPosition() {
        self.volumeDamper.frame.origin.x = .zero
        UIView.animate(withDuration: 0.5) {
            self.volumeDamper.frame.origin.x = self.frame.maxX
        } completion: { isFinished in
            if isFinished {
            animateCurrentPosition()
            }
        }
        
        func animateCurrentPosition() {
            let width = frame.width
            UIView.animate(withDuration: 0.3) {
                self.volumeDamper.frame = self.frame
                self.volumeDamper.frame.origin.x = width * CGFloat(self.volume)
            } completion: { isFinished in
                
            }
        }
        
    }
    
    private func animateGradient() {
        let startGradientColors = [[#colorLiteral(red: 0.4549019608, green: 0.2196078431, blue: 0.9568627451, alpha: 1).cgColor, #colorLiteral(red: 0.7882352941, green: 0.6352941176, blue: 0.9450980392, alpha: 1).cgColor]]
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientLayer.colors = startGradientColors.first
        //gradientAnimation.delegate = self
        gradientAnimation.duration = 1.5
        gradientAnimation.toValue = gradientColorSet.first
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        gradientLayer.add(gradientAnimation, forKey: "colors")
    }
    
    private func setVolumeDamperPosition() {
        gradientLayer.frame = self.frame
        gradientLayer.bounds = self.bounds
        let width = frame.width
        volumeDamper.frame = self.frame
        volumeDamper.frame.origin.x = width * CGFloat(volume)
    }
    
}
