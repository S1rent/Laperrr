//
//  File.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import RxSwift
import RxCocoa

extension ObservableType {
    public func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }

    public func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}