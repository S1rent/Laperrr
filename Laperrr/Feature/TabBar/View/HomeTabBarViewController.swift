//
//  HomeTabBarControllerViewController.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeTabBarViewController: UITabBarController {

    let viewModel: HomeTabBarViewModel
    let loadTrigger = BehaviorRelay<Void>(value: ())
    let disposeBag = DisposeBag()
    
    init() {
        self.viewModel = HomeTabBarViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.bindUI()
    }
    
    private func bindUI() {
        let output = self.viewModel.transform(input: HomeTabBarViewModel.Input(loadTrigger: loadTrigger.asDriver()))
        
        self.disposeBag.insert(
            output.data.drive(onNext: { [weak self] viewControllers in
                self?.viewControllers = viewControllers
            })
        )
    }
    
    private func setupView() {
        self.tabBar.tintColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.black
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.isTranslucent = false
    }

}
