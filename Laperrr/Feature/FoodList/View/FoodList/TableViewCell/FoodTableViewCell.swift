//
//  FoodTableViewCell.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import UIKit
import SDWebImage

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var labelFoodOrigin: UILabel!
    @IBOutlet weak var labelFoodCategory: UILabel!
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setData(_ data: Food) {
        self.labelFoodName.text = data.foodName ?? "-"
        self.labelFoodOrigin.text = "Origin: \(data.foodOrigin ?? "-")"
        self.labelFoodCategory.text = data.foodCategory ?? "-"
        self.imageFood.sd_setImage(with: URL(string: data.foodImageURL ?? ""), placeholderImage: #imageLiteral(resourceName: "icn-no-photo"))
    }
    
    private func setupView() {
        self.containerView.layer.cornerRadius = 6
        self.containerView.layer.borderWidth = 0.5
        self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        self.imageFood.layer.cornerRadius = 20
    }
    
}
