//
//  HomeViewController.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let refreshControl: UIRefreshControl
    let changeNavbarTitle: (_ title: String) -> Void
    
    init(callBack: @escaping (_ title: String) -> Void) {
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
