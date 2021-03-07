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
        self.title = "tes"
        
        self.setupRightBarButton()
        self.setupNavigationBar()
        self.setupTabBarView()
        self.bindUI()
    }
    
    private func bindUI() {
        let output = self.viewModel.transform(input: HomeTabBarViewModel.Input(
            loadTrigger: loadTrigger.asDriver(),
            callBack: self.changeNavigationBarTitle
        ))
        
        self.disposeBag.insert(
            output.data.drive(onNext: { [weak self] viewControllers in
                self?.viewControllers = viewControllers
            })
        )
    }
    
    private func setupNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setupTabBarView() {
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.isTranslucent = false
    }
    
    private func setupRightBarButton() {
        let buttonProfile = UIBarButtonItem(image: #imageLiteral(resourceName: "icn-profile"), style: .plain, target: self, action: #selector(navigateToProfile))
        self.navigationItem.rightBarButtonItem = buttonProfile
    }
    
    func changeNavigationBarTitle(title: String) {
        self.title = title
    }
    
    @objc func navigateToProfile() {
        let viewController = ProfileViewController()
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }

}
