//
//  CategoriesTableViewCell.swift
//  Laperrr
//
//  Created by IT Division on 07/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class CategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelName: UILabel!
    
    var data: FoodCategory?
    let viewModel = CategoriesCollectionViewModel()
    let loadTrigger = BehaviorRelay<Void>(value: ())
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCollectionView()
        self.bindUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func bindUI() {
        let output = self.viewModel.transform(input: CategoriesCollectionViewModel.Input(loadTrigger: self.loadTrigger.asDriver(),
             data: self.data 
        ))
        
        self.disposeBag.insert(
            output.data.drive(self.collectionView.rx.items(cellIdentifier: CategoriesCollectionViewCell.identifier, cellType: CategoriesCollectionViewCell.self)) { _, data, cell in
                cell.setData(data)
            }
        )
        
    }
    
    public func setData(_ data: FoodCategory) {
        self.data = data
        self.labelName.text = data.categoryName ?? ""
    }
    
    private func setupCollectionView() {
        self.collectionView.register(CategoriesCollectionViewCell.nib, forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        
        let layout: UICollectionViewFlowLayout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.collectionView.frame.width - 100, height: self.collectionView.frame.height - 5)
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
}
