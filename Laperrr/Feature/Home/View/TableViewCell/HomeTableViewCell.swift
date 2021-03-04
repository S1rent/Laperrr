//
//  HomeTableViewCell.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var labelFoodOrigin: UILabel!
    @IBOutlet weak var labelFoodCategory: UILabel!
    @IBOutlet weak var imageFood: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setData(_ data: Food) {
        
    }
    
}
