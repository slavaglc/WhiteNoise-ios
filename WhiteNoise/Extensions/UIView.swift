//
//  UIView.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 23.04.2022.
//

import UIKit

extension UIView {
    // viewController
    var viewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let responder = responder as? UIViewController {
                return responder
            }
            responder = responder?.next
        }
        return nil
    }
    
    func removeAllViewsFromNavigation() {
        viewController?.navigationController?.view.subviews.forEach({ view in
            if view is UIButton || view is UIImageView { // fixme:
                view.removeFromSuperview()
            }
        })
    }
    
    func changeAnimationByAlpha(change: @escaping ()->() = {}) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            change()
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1.0
            })
        })
    }
    
    func changeAnimationByTranslate(change: @escaping ()->() = {}) {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform.translatedBy(x: 10, y: 0)
        }, completion: { _ in
            change()
            UIView.animate(withDuration: 0.3, animations: {
                self.transform.translatedBy(x: 0, y: 0)
            })
        })
    }
    
    func fadeInFromLeftSide(completionAnimation: @escaping ()->() = {}) {
        let targetCenter = center
        center = CGPoint(x: 0, y: targetCenter.y)
        alpha = 0.0
        isHidden = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.center = CGPoint(x: targetCenter.x, y: targetCenter.y)
            self?.alpha = 1.0
        } completion: { isFinished in
            if isFinished {
                completionAnimation()
            }
        }
    }
        
    func fadeOutToLeftSide(completionAnimation: @escaping ()->() = {}) {
        let targetCenter = center
        center = CGPoint(x: targetCenter.x, y: targetCenter.y)
        alpha = 1.0
        isHidden = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.center = CGPoint(x: 0, y: targetCenter.y)
            //self?.alpha = 0.0
        } completion: { [weak self] isFinished in
            if isFinished {
                self?.isHidden = true
                self?.center = targetCenter
                completionAnimation()
            }
        }
    }

    
    func halfFadeOut(completionAnimation: @escaping ()->() = {}) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.alpha = 0.5
        } completion: { isFinished in
            if isFinished {
            completionAnimation()
            }
        }
    }
    
    func halfFadeIn(completionAnimation: @escaping ()->() = {}) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.alpha = 1
        } completion: { isFinished in
            if isFinished {
            completionAnimation()
            }
        }
    }
}
