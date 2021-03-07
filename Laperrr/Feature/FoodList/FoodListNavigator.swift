//
//  FoodListNavigator.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import Foundation
import UIKit

class FoodListNavigator {
    let navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    public func goToFoodDetail(data: Food) {
        let viewController = FoodDetailViewController(data: data)
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
}
