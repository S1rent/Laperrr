//
//  CategoriesCollectionViewModel.swift
//  Laperrr
//
//  Created by IT Division on 07/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class CategoriesCollectionViewModel: ViewModel {
    public struct Input {
        let loadTrigger: Driver<Void>
        let data: FoodCategory?
    }
    
    public struct Output {
        let data: Driver<[Food]>
    }
    
    public func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityIndicator()
        
        let foodData = input.data
        
        let data = input.loadTrigger.flatMapLatest { _ -> Driver<[Food]> in
            return CategoriesNetworkProvider.shared
                .getFoodByCategory(with: foodData?.categoryName ?? "")
                .trackError(errorTracker)
                .trackActivity(activityTracker)
                .asDriverOnErrorJustComplete()
        }
        
        return Output(data: data)
    }
}
