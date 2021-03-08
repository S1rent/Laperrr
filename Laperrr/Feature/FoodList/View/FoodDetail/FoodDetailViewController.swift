//
//  FoodDetailViewController.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import UIKit
import RxCocoa
import RxSwift
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
    
    var data: Food
    let needAPICall: Bool
    let loadTrigger: BehaviorRelay<Void>
    let viewModel: FoodDetailViewModel
    let disposeBag: DisposeBag
    
    init(data: Food, needAPICall: Bool = false) {
        self.data = data
        self.needAPICall = needAPICall
        self.loadTrigger = BehaviorRelay<Void>(value: ())
        self.viewModel = FoodDetailViewModel(data: data)
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Food Detail"
        
        self.setupView()
        
        if needAPICall {
            self.bindUI()
        } else {
            self.setData()
        }
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
    
    private func bindUI() {
        let output = self.viewModel.transform(input: FoodDetailViewModel.Input(loadTrigger: self.loadTrigger.asDriver()
        ))
        
        self.disposeBag.insert(
            output.data.drive(onNext:{ [weak self] data in
                guard let self = self else { return }
                self.data = data
                self.setData()
            })
        )
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
