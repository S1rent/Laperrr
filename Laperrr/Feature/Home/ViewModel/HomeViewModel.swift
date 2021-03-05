//
//  HomeViewModel.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import RxCocoa
import RxSwift

final class HomeViewModel: ViewModel {
    
    public struct Input {
        let loadTrigger: Driver<Void>
        let refreshTrigger: Driver<Void>
    }
    
    public struct Output {
        let data: Driver<[Food]>
        let loading: Driver<Bool>
        let noData: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let activityTracker = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let data = Driver.merge(input.refreshTrigger, input.loadTrigger).flatMap{ _ -> Driver<[Food]> in
                   
            var foods: [Food] = []
            for _ in 1...10 {
                HomeNetworkProvider.shared.getRandomFood().trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .do(onNext: { food in
                        foods.append(contentsOf: food)
                    })
            }
            print(foods)
            return Driver.just(foods)
        }
        
        let noData = data.filter{ $0.isEmpty }.map{ _ in }
        
        return Output(data: data, loading: activityTracker.asDriver(), noData: noData)
    }
    
}
