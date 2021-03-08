//
//  CategoriesNavigator.swift
//  Laperrr
//
//  Created by IT Division on 08/03/21.
//

import Foundation
import UIKit

class CategoriesNavigator {
    private let navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    public func goToFoodListByCategory(data: FoodCategory) {
        let viewController = FoodListByCategoryViewController(data: data)
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
}
