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
    func hideWithAnimation(_ duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0
        } completion: { [weak self] _ in
            self?.isHidden = true
        }
    }
    
    func showWithAnimation(_ duration: TimeInterval = 0.3) {
        self.alpha = 0
        UIView.animate(withDuration: duration) {
            self.isHidden = false
            self.alpha = 1
        }
    }
    
    @objc func dismissKeyboad() {
        self.endEditing(true)
    }
}
