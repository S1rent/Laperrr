//
//  FoodNavigator.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import Foundation
import UIKit

class FoodNavigator {
    
    let navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    public func goToFoodDetail(data: Food, needAPICall: Bool = false) {
        let viewModel = FoodDetailViewModel(data: data)
        let viewController = FoodDetailViewController(data: data, needAPICall: needAPICall, viewModel: viewModel)
        
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func goToFoodListByCategory(data: FoodCategory) {
        let viewModel = FoodListByCategoryViewModel(data)
        let viewController = FoodListByCategoryViewController(data: data, viewModel: viewModel)
        
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
}
