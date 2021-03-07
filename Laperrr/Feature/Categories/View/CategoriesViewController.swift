//
//  CategoriesViewController.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl: UIRefreshControl
    let changeNavbarTitle: (_ title: String) -> Void
    let viewModel: CategoriesViewModel
    let loadTrigger = BehaviorRelay<Void>(value: ())
    let disposeBag: DisposeBag
    
    init(callBack: @escaping (_ title: String) -> Void) {
        self.changeNavbarTitle = callBack
        self.viewModel = CategoriesViewModel()
        self.refreshControl = UIRefreshControl()
        self.disposeBag = DisposeBag()
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
        
        self.bindUI()
        self.setupTableView()
    }
    
    private func bindUI() {
        let refresh = self.tableView.refreshControl?.rx.controlEvent(.valueChanged).mapToVoid().asDriverOnErrorJustComplete() ?? Driver.empty()
        
        let output = self.viewModel.transform(input: CategoriesViewModel.Input(loadTrigger: self.loadTrigger.asDriver(), refreshTrigger: refresh
        ))
        
        self.disposeBag.insert(
            output.data.drive(self.tableView.rx.items(cellIdentifier: CategoriesTableViewCell.identifier, cellType: CategoriesTableViewCell.self)) { (_, data, cell) in
                cell.setData(data)
            }
        )
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: CategoriesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        self.tableView.refreshControl = self.refreshControl
        self.tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.tableView.estimatedRowHeight = 256.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }

}
