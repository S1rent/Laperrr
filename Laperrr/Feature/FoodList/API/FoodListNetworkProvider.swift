//
//  FoodListNetworkProvider.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class FoodListNetworkProvider {
    
    private let provider = MoyaProvider<FoodListTarget>()
    public static let shared = FoodListNetworkProvider()
    private init() {}
    
    public func getRandomFood() -> Observable<[Food]> {
        let requestToken = FoodListTarget.getRandomFood
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(FoodListResponseWrapper.self)
            .map { $0.data ?? [] }
            .asObservable()
    }
    
    public func getSearchedFood(with text: String) -> Observable<[Food]> {
        let requestToken = FoodListTarget.getSearchedFood(text: text)
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(FoodListResponseWrapper.self)
            .map { $0.data ?? [] }
            .asObservable()
    }
}
