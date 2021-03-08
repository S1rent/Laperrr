//
//  FoodListByCategoryViewmodel.swift
//  Laperrr
//
//  Created by IT Division on 08/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class FoodListByCategoryViewModel: ViewModel {
    public struct Input {
        let loadTrigger: Driver<Void>
        let refreshTriger: Driver<Void>
    }
    
    public struct Output {
        let data: Driver<[Food]>
        let loading: Driver<Bool>
        let noData: Driver<Bool>
    }
    
    let data: FoodCategory
    
    init(_ data: FoodCategory) {
        self.data = data
    }
    
    public func transform(input: Input) -> Output {
        let activityTracker = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let data = Driver.merge(input.loadTrigger, input.refreshTriger).flatMapLatest { _ -> Driver<[Food]> in
            
            return FoodNetworkProvider.shared
                .getFoodByCategory(with: self.data.categoryName ?? "")
                .trackError(errorTracker)
                .trackActivity(activityTracker)
                .asDriverOnErrorJustComplete()
        }
        
        let noData = data.map { !$0.isEmpty }
        
        return Output(data: data,
            loading: activityTracker.asDriver(),
            noData: noData
        )
    }
}
