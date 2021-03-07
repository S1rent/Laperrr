//
//  CategoriesTableViewCell.swift
//  Laperrr
//
//  Created by IT Division on 07/03/21.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setData(_ data: FoodCategory) {
        self.labelName.text = data.categoryName ?? ""
    }
    
    private func setupCollectionView() {
        self.collectionView.register(CategoriesCollectionViewCell.nib, forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        
        let layout: UICollectionViewFlowLayout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.collectionView.frame.width - 100, height: self.collectionView.frame.height - 5)
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
}
