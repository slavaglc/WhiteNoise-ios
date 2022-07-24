//
//  ImageBackgroundView.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 01.05.2022.
//

import UIKit
import CryptoKit

enum SelectedStyle {
    case selected(animated: Bool, volume: Float), unselected(animated: Bool)
}

final class ImageBackgroundView: UIView, CAAnimationDelegate {
    
    private enum PositionAnimationType {
        case forward, back
    }
    
    private let gradientLayer = CAGradientLayer()
    private var gradientColorSet: [[CGColor]] = [[#colorLiteral(red: 0.7882352941, green: 0.6352941176, blue: 0.9450980392, alpha: 1).cgColor, #colorLiteral(red: 0.4549019608, green: 0.2196078431, blue: 0.9568627451, alpha: 1).cgColor]]
    private var colorIndex: Int = 0
    private var volume: Float = 0.0
    private var lastSize: CGSize = .zero
    private var isAnimating = false
    
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
        if self.window != nil, lastSize != .zero, gradientLayer.bounds.size != lastSize {
            // React to the size change
            if !isAnimating {
                setGradientWidthByVolume()
            }
        } else {
            gradientLayer.frame = self.frame
            gradientLayer.bounds = self.bounds
            if !isAnimating {
                setGradientWidthByVolume()
            }
        }
        
        lastSize = gradientLayer.bounds.size
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        switch anim.value(forKey: "bounds") as? String {
        case "back":
            setGradientWidthByVolume()
        default:
            break
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            switch anim.value(forKey: "bounds") as? String {
            case "forward":
                gradientLayer.bounds = self.bounds
                animateBackPosistion()
            case "back":
                isAnimating = false
            default:
                break
            }
            
        }
    }
    
    private func initialize() {
        backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1137254902, blue: 0.3254901961, alpha: 1)
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
        //        print("selected volume:", volume)
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
        guard animated else {
            isAnimating = false
//            layoutSubviews()
            ;return }
        isAnimating = true
        //        animatePosistion(direction: .forward)
        animatePosistion()
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
        //gradientAnimation.delegate = self
        gradientAnimation.duration = 1.5
        gradientAnimation.toValue = gradientColorSet.first
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        gradientLayer.add(gradientAnimation, forKey: "colors")
    }
    
    private func animatePosistion() {
        gradientLayer.anchorPoint.x = .zero
        let newBounds = self.frame
        
        let oldBounds = CGRect(x: .zero, y: .zero, width: 0, height: self.bounds.height)
        //        let oldBounds: CGFloat = .zero
        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.setValue("forward", forKey: "bounds")
        boundsAnimation.fromValue = oldBounds
        boundsAnimation.toValue = newBounds
        boundsAnimation.delegate = self
        boundsAnimation.duration = 0.3
        boundsAnimation.fillMode = .forwards
        boundsAnimation.isRemovedOnCompletion = false
        gradientLayer.add(boundsAnimation, forKey: "bounds")
    }
    
    private func animateBackPosistion() {
        let newBounds = CGRect(origin: gradientLayer.bounds.origin, size: CGSize(width: (gradientLayer.bounds.width * CGFloat(volume)), height: gradientLayer.bounds.height))
        
        let oldBounds = CGRect(origin: gradientLayer.bounds.origin, size: gradientLayer.bounds.size)
        //        let oldBounds: CGFloat = .zero
        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.setValue("back", forKey: "bounds")
        boundsAnimation.fromValue = oldBounds
        boundsAnimation.toValue = newBounds
        boundsAnimation.delegate = self
        boundsAnimation.duration = 0.3
        boundsAnimation.isRemovedOnCompletion = false
        gradientLayer.add(boundsAnimation, forKey: "bounds")
    }
    
    private func setGradientWidthByVolume() {
        gradientLayer.frame = self.frame
        gradientLayer.frame.size.width *=  CGFloat(volume)
        gradientLayer.bounds = self.bounds
        gradientLayer.bounds.size.width *=  CGFloat(volume)
    }
    
    //    private func animatePosistion(direction: PositionAnimationType, pos: CGFloat = .zero, duration: CFTimeInterval = 0.5) {
    ////        let zeroPosition: CGFloat = pos - (layer.bounds.width / 2)
    ////        let newPosition =  direction == .forward ? layer.position.x  : zeroPosition
    ////        let oldPosition: CGFloat = direction == .forward ? zeroPosition : layer.position.x
    //        let newPosition = layer.bounds.width
    //        let oldPosition: CGFloat = .zero
    //
    //        let boundsAnimation = CABasicAnimation(keyPath: "position.x")
    //        boundsAnimation.fromValue = oldPosition
    //        boundsAnimation.toValue = newPosition
    //        boundsAnimation.duration = duration
    //        gradientLayer.add(boundsAnimation, forKey: "position.x")
    //    }
}
