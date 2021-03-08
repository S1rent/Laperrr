//
//  FoodDetailViewModel.swift
//  Laperrr
//
//  Created by IT Division on 08/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class FoodDetailViewModel: ViewModel {
    public struct Input {
        let loadTrigger: Driver<Void>
    }
    
    public struct Output {
        let data: Driver<Food>
        let loading: Driver<Bool>
    }
    
    let data: Food
    
    init(data: Food) {
        self.data = data
    }
    
    func transform(input: Input) -> Output {
        let activityTracker = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let data = input.loadTrigger.flatMap{ _ -> Driver<Food> in
           
            return FoodListNetworkProvider.shared
                .getFoodDetailByID(with: self.data.foodID ?? "")
                .trackActivity(activityTracker)
                .trackError(errorTracker)
                .filterNil()
                .asDriverOnErrorJustComplete()
        }
        
        return Output(data: data,
                      loading: activityTracker.asDriver()
        )
    }
}
