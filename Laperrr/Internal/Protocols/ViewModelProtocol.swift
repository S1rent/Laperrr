//
//  ViewModelProtocol.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
