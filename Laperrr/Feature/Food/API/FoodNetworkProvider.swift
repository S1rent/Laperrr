//
//  FoodNetworkProvider.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class FoodNetworkProvider {
    private let provider = MoyaProvider<FoodTarget>()
    public static let shared = FoodNetworkProvider()
    
    private init() {}
    
    public func getRandomFood() -> Observable<[Food]> {
        let requestToken = FoodTarget.getRandomFood
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(FoodListResponseWrapper.self)
            .map { $0.data ?? [] }
            .asObservable()
    }
    
    public func getSearchedFood(with text: String) -> Observable<[Food]> {
        let requestToken = FoodTarget.getSearchedFood(text: text)
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(FoodListResponseWrapper.self)
            .map { $0.data ?? [] }
            .asObservable()
    }
    
    public func getFoodDetailByID(with id: String) -> Observable<Food?> {
        let requestToken = FoodTarget.getFoodDetailByID(id: id)
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(FoodListResponseWrapper.self)
            .map { $0.data?.first}
            .asObservable()
    }
    
    public func getFoodCategories() -> Observable<[FoodCategory]> {
        let requestToken = FoodTarget.getFoodCategories
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(FoodCategoriesResponseWrapper.self)
            .map { $0.data ?? [] }
            .asObservable()
    }
    
    public func getFoodByCategory(with category: String) -> Observable<[Food]> {
        let requestToken = FoodTarget.getFoodListByCategories(category: category)
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(FoodListResponseWrapper.self)
            .map { $0.data ?? [] }
            .asObservable()
    }
}
