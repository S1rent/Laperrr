//
//  FoodDetailViewController.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import UIKit

class FoodDetailViewController: UIViewController {
    
    let data: Food
    
    init(data: Food) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Food Detail"
    }

}
