//
//  MenuViewController.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import UIKit

final class HomeTabBarViewControllerList {
    public init() { }
    
    static let shared = HomeTabBarViewControllerList()
    var callBack: ((_ title: String) -> Void) = { _ in }
    
    func getHomeViewController() -> UIViewController {
        let viewController = HomeViewController(callBack: callBack)
        viewController.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "icn-home"), tag: 0)
        viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: -5, left: -5, bottom: -5, right: -5)
        
        return viewController
    }
    
    func getCategoryListViewController() -> UIViewController {
        let viewController = CategoriesViewController(callBack: callBack)
        viewController.tabBarItem = UITabBarItem(title: "Categories", image: #imageLiteral(resourceName: "icn-category"), tag: 1)
        viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: -5, left: -5, bottom: -5, right: -5)
        
        return viewController
    }
    
    func setTitleChangeCallback(callBack: @escaping (_ title: String) -> Void) {
        self.callBack = callBack
    }
}
