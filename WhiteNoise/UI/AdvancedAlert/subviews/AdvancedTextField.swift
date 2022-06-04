//
//  AdvancedTextField.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 03.06.2022.
//

import UIKit


enum CustomBorderStyle {
    case bottom(borderColor: UIColor)
    case top(borderColor: UIColor)
    case none
}

final class AdvancedTextField: UITextField {
    
    var padding: CGFloat = 0
    var bottomLine =  CALayer()
    
    var placeholderColor: UIColor = .lightGray
    {
        didSet{
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
    
    private var rect = CGRect()
    private var customBorderStyle: CustomBorderStyle = .none
    
    convenience init(borderStyle: CustomBorderStyle) {
        self.init()
        customBorderStyle = borderStyle
        switch customBorderStyle {
        case .bottom(let borderColor):
            rect = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
            addBottomBorder(frame: rect)
            bottomLine.backgroundColor = borderColor.cgColor
        case .top(borderColor: let borderColor):
            rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1)
            addBottomBorder(frame: rect)
            bottomLine.backgroundColor = borderColor.cgColor
        case .none:
            break
        }
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        switch customBorderStyle {
        case .bottom(_):
            bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        case .top(_):
            rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1)
        case .none:
            break
        }
    }
    
    
    private func addBottomBorder(frame: CGRect) {
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.red.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
