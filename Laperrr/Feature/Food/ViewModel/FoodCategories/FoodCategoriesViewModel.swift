//
//  FoodCategoriesViewModel.swift
//  Laperrr
//
//  Created by IT Division on 07/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class FoodCategoriesViewModel: ViewModel {
    public struct Input {
        let loadTrigger: Driver<Void>
        let refreshTrigger: Driver<Void>
    }
    
    public struct Output {
        let data: Driver<[FoodCategory]>
        let loading: Driver<Bool>
        let noData: Driver<Bool>
    }
    
    public func transform(input: Input) -> Output {
        let activityTracker = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let data = Driver.merge(input.loadTrigger, input.refreshTrigger).flatMapLatest { _ -> Driver<[FoodCategory]> in
            return FoodNetworkProvider.shared.getFoodCategories().trackError(errorTracker)
                .trackActivity(activityTracker)
                .asDriverOnErrorJustComplete()
        }
        
        let noData = data.map{ !$0.isEmpty }
        
        return Output(data: data,
                      loading: activityTracker.asDriver(),
                      noData: noData
        )
    }
}
