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
}
