//
//  HomeViewController.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeNavbarTitle("Home")
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchBar()
        self.setupTableView()
        self.bindUI()
    }
    
    private func bindUI() {
        let refreshTrigger = self.tableView.refreshControl?.rx.controlEvent(.valueChanged).mapToVoid().asDriverOnErrorJustComplete() ?? Driver.empty()
        
        let output = self.viewModel.transform(input: HomeViewModel.Input(loadTrigger: self.loadTrigger.asDriver(), refreshTrigger: refreshTrigger))
        
        self.disposeBag.insert(
            output.data.drive(self.tableView.rx.items(cellIdentifier: HomeTableViewCell.identifier, cellType: HomeTableViewCell.self)){ (_, data, cell) in
                cell.setData(data)
            },
            output.loading.drive(onNext: { [weak self] loading in
                if loading {
                    self?.tableView.refreshControl?.alpha = 0
                    let height = self?.refreshControl.frame.height
                    self?.tableView.setContentOffset(CGPoint(x: 0, y: -(height ?? 0)), animated: true)
                    self?.activityIndicator.startAnimating()
                    self?.activityIndicator.isHidden = false
                    self?.activityIndicator.alpha = 1
                    self?.noResultView.isHidden = true
                } else {
                    self?.refreshControl.endRefreshing()
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.alpha = 0
                }
            }),
            output.noData.drive(self.noResultView.rx.isHidden)
        )
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: HomeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomeTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.refreshControl = self.refreshControl
        self.tableView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.tableView.estimatedRowHeight = 256.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupSearchBar() {
        self.searchBar.tintColor = UIColor.white
        self.searchBar.backgroundColor = UIColor.white
        self.searchBar.isTranslucent = false
        self.searchBar.placeholder = "Search foodies..."
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height)
        cell.alpha = 0
        cell.selectionStyle = .none
        UIView.animate(
            withDuration: 1.2,
            delay: 0.02,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.1,
            options: [.curveEaseInOut],
            animations: {
                cell.alpha = 1
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
}
