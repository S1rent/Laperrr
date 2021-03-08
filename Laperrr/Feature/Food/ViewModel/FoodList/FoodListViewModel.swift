//
//  FoodListViewModel.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import RxCocoa
import RxSwift

final class FoodListViewModel: ViewModel {
    public struct Input {
        let loadTrigger: Driver<Void>
        let refreshTrigger: Driver<Void>
        let searchTrigger: Driver<String>
    }
    
    public struct Output {
        let data: Driver<[Food]>
        let loading: Driver<Bool>
        let noData: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let activityTracker = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let disposeBag = DisposeBag()
        let dataRelay = BehaviorRelay<[Food]>(value: [])
        var searchedKey = ""
        
        let data = Driver.merge(input.refreshTrigger, input.loadTrigger).flatMap{ _ -> Driver<[Food]> in
            
            dataRelay.accept([])
            
            for _ in 0...15 {
                FoodNetworkProvider.shared.getRandomFood().trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .do(onNext: { data in
                        dataRelay.accept(dataRelay.value + data)
                    }).drive().disposed(by: disposeBag)
            }
           
            return dataRelay.asDriver()
        }
        
        let searchedData = input.searchTrigger.flatMapLatest { searchedFood -> Driver<[Food]> in
            searchedKey = searchedFood
            return FoodNetworkProvider.shared.getSearchedFood(with: searchedFood)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
        }
        
        let combinedData = Driver.combineLatest(data, searchedData).map { (data, searchedData) -> [Food] in
            var dataArray: [Food] = []
            
            if searchedKey == "" {
                dataArray = data
            } else {
                dataArray = searchedData
            }
            return dataArray
        }
        
        let noData = combinedData.map{ !$0.isEmpty }
        
        return Output(data: combinedData,
                      loading: activityTracker.asDriver(),
                      noData: noData)
    }
    
}
