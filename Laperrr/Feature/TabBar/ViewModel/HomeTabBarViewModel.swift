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
    }
    
    public struct Output {
        let data: Driver<[UIViewController]>
    }
    
    func transform(input: Input) -> Output {
        let viewControllers = input.loadTrigger.flatMapLatest { _ -> Driver<[UIViewController]>in
            
            let vcList = HomeTabBarViewControllerList.shared
            let tabVCList = [
                vcList.getHomeViewController(),
                vcList.getCategoryListViewController()
            ]
            
            return Driver.just(tabVCList)
        }
        
        return Output(data: viewControllers)
    }
    
    
}
