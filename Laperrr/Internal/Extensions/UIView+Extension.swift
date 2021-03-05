//
//  UIView+Extension.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.sublayers?.removeAll(where: {$0 is CAGradientLayer})
        layer.insertSublayer(gradientLayer, at: 0)
        
        return gradientLayer
    }
}
