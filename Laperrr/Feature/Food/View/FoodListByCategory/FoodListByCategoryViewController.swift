//
//  FoodListByCategoryViewController.swift
//  Laperrr
//
//  Created by IT Division on 08/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class FoodListByCategoryViewController: UIViewController {
    
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
    let loadTrigger: BehaviorRelay<Void>
    let viewModel: FoodListByCategoryViewModel
    let data: FoodCategory
    
    var navigator: FoodNavigator?
    var hasData: Bool = false

    init(
        data: FoodCategory,
        viewModel: FoodListByCategoryViewModel
    ){
        self.data = data
        self.viewModel = viewModel
        self.refreshControl = UIRefreshControl()
        self.loadTrigger = BehaviorRelay<Void>(value: ())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.data.categoryName ?? "") Category"
        self.navigator = FoodNavigator(navigationController: self.navigationController)

        self.setupTableView()
        
        self.bindUI()
    }

    private func bindUI() {
        let refresh = self.tableView.refreshControl?.rx.controlEvent(.valueChanged).mapToVoid().asDriverOnErrorJustComplete() ?? Driver.empty()
        
        let output = self.viewModel.transform(input: FoodListByCategoryViewModel.Input(
            loadTrigger: self.loadTrigger.asDriver(),
            refreshTriger: refresh
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(self.tableView.rx.items(cellIdentifier: FoodTableViewCell.identifier, cellType: FoodTableViewCell.self)) { (_, data, cell) in
                cell.setData(data)
                cell.labelFoodOrigin.isHidden = true
                cell.labelFoodCategory.isHidden = true
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
                    
                    self.noResultView.isHidden = self.hasData
                }
            }),
            output.noData.drive(onNext: { [weak self] hasData in
                guard let self = self else { return }
                
                self.hasData = hasData
            })
        )
    }
    
    private func setupTableView() {
        self.tableView.register(FoodTableViewCell.nib, forCellReuseIdentifier: FoodTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.refreshControl = self.refreshControl
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.refreshControl?.alpha = 0
        self.tableView.rx.modelSelected(Any.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                if let foodData = data as? Food {
                    self.navigator?.goToFoodDetail(data: foodData, needAPICall: true)
                }
                self.deselectTableView()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.rx.disposeBag)
    }
    
    private func deselectTableView() {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
}

extension FoodListByCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 2, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            cell.alpha = 1
        }, completion: nil)
    }
}
