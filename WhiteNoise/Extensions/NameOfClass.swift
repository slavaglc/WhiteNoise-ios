//
//  NameOfClass.swift
//  WhiteNoise
//
//  Created by Вячеслав Макаров on 21.04.2022.
//

import Foundation


extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
