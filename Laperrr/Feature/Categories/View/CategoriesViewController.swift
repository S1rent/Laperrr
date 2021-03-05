//
//  CategoriesViewController.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    let changeNavbarTitle: (_ title: String) -> Void
    
    init(callBack: @escaping (_ title: String) -> Void) {
        self.changeNavbarTitle = callBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeNavbarTitle("Food Categories")
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
