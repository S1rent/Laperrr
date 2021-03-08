//
//  CategoriesTableViewCell.swift
//  Laperrr
//
//  Created by IT Division on 07/03/21.
//

import UIKit
import SDWebImage

class CategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    var dataSource: [Food] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setData(_ data: FoodCategory) {
        self.labelName.text = data.categoryName ?? ""
        self.imageFood.sd_setImage(with: URL(string: data.categoryImage ?? ""), placeholderImage: #imageLiteral(resourceName: "icn-no-photo"))
    }
    
    private func setupView() {
        self.imageFood.layer.cornerRadius = 6
        self.imageFood.layer.borderWidth = 0.6
        self.imageFood.layer.borderColor = UIColor.gray.cgColor
    }
}
