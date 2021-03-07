//
//  CategoriesNetworkProvider.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class CategoriesNetworkProvider {
    
    private let provider = MoyaProvider<CategoryTarget>()
    public static let shared = CategoriesNetworkProvider()
    private init() {}
    
    public func getFoodCategories() -> Observable<[FoodCategory]> {
        let requestToken =  CategoryTarget.getFoodCategories
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(FoodCategoriesResponseWrapper.self)
            .map { $0.data ?? [] }
            .asObservable()
    }
    
    public func getFoodByCategory(with category: String) -> Observable<[Food]> {
        let requestToken =  CategoryTarget.getFoodListByCategories(category: category)
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(FoodListResponseWrapper.self)
            .map { $0.data ?? [] }
            .asObservable()
    }
}
