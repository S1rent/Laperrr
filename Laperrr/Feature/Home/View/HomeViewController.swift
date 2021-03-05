//
//  HomeViewController.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel: HomeViewModel
    let loadTrigger = BehaviorRelay<Void>(value: ())
    let refreshControl: UIRefreshControl
    let changeNavbarTitle: (_ title: String) -> Void
    let disposeBag: DisposeBag
    
    init(callBack: @escaping (_ title: String) -> Void) {
        self.disposeBag = DisposeBag()
        self.viewModel = HomeViewModel()
        self.refreshControl = UIRefreshControl()
        self.changeNavbarTitle = callBack
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeNavbarTitle("Home")
        
        self.setupTableView()
        self.bindUI()
    }
    
    private func bindUI() {
        let refreshTrigger = self.tableView.refreshControl?.rx.controlEvent(.valueChanged).mapToVoid().asDriverOnErrorJustComplete() ?? Driver.empty()
        
        let output = self.viewModel.transform(input: HomeViewModel.Input(loadTrigger: self.loadTrigger.asDriver(), refreshTrigger: refreshTrigger))
        
        self.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                print(data)
            }),
            output.loading.drive(onNext: { [weak self] loading in
                
            }),
            output.noData.drive(onNext: { [weak self] noData in
                
            })
        )
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "ThesisTableViewCell", bundle: nil), forCellReuseIdentifier: "ThesisTableViewCell")
        self.tableView.delegate = self
        self.tableView.refreshControl = self.refreshControl
        self.tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.tableView.estimatedRowHeight = 256.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }

}

extension HomeViewController: UITableViewDelegate {
    
}
