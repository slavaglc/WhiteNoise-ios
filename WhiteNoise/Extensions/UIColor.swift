//
//  UIColor.swift
//  WhiteNoise
//
//  Created by Victor Varenik on 23.04.2022.
//

import UIKit

extension UIColor {
    // get uicolor for normal RGB values (0-255)
    static func fromNormalRgb(red: Int, green: Int, blue: Int, alpha: Int = 255) -> UIColor {
       return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
   }
}
