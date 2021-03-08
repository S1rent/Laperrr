//
//  HomeTabBarViewModel.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeTabBarViewModel: ViewModel {
    public struct Input {
        let loadTrigger: Driver<Void>
        let callBack: (_ title: String) -> Void
    }
    
    public struct Output {
        let data: Driver<[UIViewController]>
    }
    
    func transform(input: Input) -> Output {
        let viewControllers = input.loadTrigger.flatMapLatest { _ -> Driver<[UIViewController]>in
            
            let vcList = HomeTabBarViewControllerList.shared
            HomeTabBarViewControllerList.shared.setTitleChangeCallback(callBack: input.callBack)
            
            let tabVCList = [
                vcList.getFoodListViewController(),
                vcList.getCategoryListViewController()
            ]
            
            return Driver.just(tabVCList)
        }
        
        return Output(data: viewControllers)
    }
    
    
}
