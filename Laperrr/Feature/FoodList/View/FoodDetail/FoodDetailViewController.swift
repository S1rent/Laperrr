//
//  FoodDetailViewController.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import UIKit
import youtube_ios_player_helper

class FoodDetailViewController: UIViewController {
    
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var youtubeView: YTPlayerView!
    @IBOutlet weak var labelOrigin: UILabel!
    @IBOutlet weak var labelFoodCategory: UILabel!
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var labelInstructions: UILabel!
    @IBOutlet weak var labelTags: UILabel!
    @IBOutlet weak var embedView: UIView!
    
    let data: Food
    
    init(data: Food) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Food Detail"
        
        self.setupView()
        self.setData()
    }
    
    private func setData() {
        self.imageFood.sd_setImage(with: URL(string: data.foodImageURL ?? ""), placeholderImage: #imageLiteral(resourceName: "icn-no-photo"))
        self.labelFoodName.text = data.foodName ?? ""
        self.labelOrigin.text = "Origin: \(data.foodOrigin ?? "")"
        self.labelInstructions.text = data.foodInstructions ?? ""
        self.labelFoodCategory.text = "Category: \(data.foodCategory ?? "")"
        
        self.labelTags.text = data.foodTags ?? "None"
        
        if let youtubeURL = self.data.foodYoutubeURL ?? "" {
            let urlSplit = youtubeURL.split(separator: "=")
            if urlSplit.count != 2 { return }
            self.youtubeView.load(withVideoId: String(urlSplit[1]))
        }
    }
    
    private func setupView() {
        self.imageFood.layer.cornerRadius = 6
        self.imageFood.layer.borderWidth = 0.6
        self.imageFood.layer.borderColor = UIColor.gray.cgColor
        self.embedView.layer.cornerRadius = 6
        self.embedView.layer.borderColor = UIColor.gray.cgColor
        self.embedView.layer.borderWidth = 0.6
    }

}
