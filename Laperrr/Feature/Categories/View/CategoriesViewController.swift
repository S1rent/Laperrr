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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            self.activityIndicator.isHidden = true
            self.activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.activityIndicator.color = UIColor.white
            self.activityIndicator.backgroundColor = UIColor.black
            self.activityIndicator.layer.cornerRadius = 6
            self.activityIndicator.snp.makeConstraints { make in
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
        }
    }
    
    private lazy var noResultView: UILabel = {
        let label = UILabel()
        label.text = "No Data"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.38)
        tableView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return label
    }()
    
    let refreshControl: UIRefreshControl
    let changeNavbarTitle: (_ title: String) -> Void
    let viewModel: CategoriesViewModel
    let loadTrigger = BehaviorRelay<Void>(value: ())
    let disposeBag: DisposeBag
    var navigator: CategoriesNavigator?
    private var hasData: Bool = false
    
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
        self.navigator = CategoriesNavigator(navigationController: self.navigationController)
        
        self.setupTableView()
        self.bindUI()
    }
    
    private func bindUI() {
        let refresh = self.tableView.refreshControl?.rx.controlEvent(.valueChanged).mapToVoid().asDriverOnErrorJustComplete() ?? Driver.empty()
        
        let output = self.viewModel.transform(input: CategoriesViewModel.Input(loadTrigger: self.loadTrigger.asDriver(), refreshTrigger: refresh
        ))
        
        self.disposeBag.insert(
            output.data.drive(self.tableView.rx.items(cellIdentifier: CategoriesTableViewCell.identifier, cellType: CategoriesTableViewCell.self)) { (_, data, cell) in
                cell.setData(data)
            },
            output.loading.drive(onNext: { [weak self] loading in
                guard let self = self else { return }
                if loading {
                    let height = self.refreshControl.frame.height
                    self.tableView.setContentOffset(CGPoint(x: 0, y: -(height )), animated: true)
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.alpha = 1
                    self.noResultView.isHidden = true
                } else {
                    self.refreshControl.endRefreshing()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.alpha = 0
                    
                    if !(self.hasData) {
                        self.noResultView.isHidden = false
                    }
                }
            }),
            output.noData.drive(onNext: { [weak self] hasData in
                guard let self = self else { return }
                self.hasData = hasData
            })
        )
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: CategoriesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.refreshControl = self.refreshControl
        self.tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.tableView.estimatedRowHeight = 256.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.refreshControl?.alpha = 0
        self.tableView.rx.modelSelected(Any.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                if let foodCategoryData = data as? FoodCategory {
                    self.navigator?.goToFoodListByCategory(data: foodCategoryData)
                }
                
                self.deselectTableView()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
    }
    
    private func deselectTableView() {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 2, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            cell.alpha = 1
        }, completion: nil)
    }
}
