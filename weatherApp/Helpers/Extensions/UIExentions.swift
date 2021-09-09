//
//  UIExentions.swift
//  weatherApp
//
//  Created by Dmytro Pupena on 23.06.2021.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: a)
    }
}

extension UIView {
    @objc func dismissKeyboad() {
        self.endEditing(true)
    }
}
