//
//  FoodDetailViewController.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
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
    @IBOutlet weak var noData: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
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
    
    var data: Food
    let needAPICall: Bool
    let loadTrigger: BehaviorRelay<Void>
    let viewModel: FoodDetailViewModel
    
    init(data: Food, needAPICall: Bool = false) {
        self.data = data
        self.needAPICall = needAPICall
        self.loadTrigger = BehaviorRelay<Void>(value: ())
        self.viewModel = FoodDetailViewModel(data: data)
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
        
        self.scrollView.alpha = 0
        UIView.animate(withDuration: 2, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.scrollView.alpha = 1
        }, completion: nil)
    }
    
    private func bindUI() {
        let output = self.viewModel.transform(input: FoodDetailViewModel.Input(loadTrigger: self.loadTrigger.asDriver()
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext:{ [weak self] data in
                guard let self = self else { return }
                self.data = data
                self.setData()
            }),
            output.loading.drive(onNext: { [weak self] loading in
                guard let self = self else { return }
                if loading {
                    self.noData.isHidden = true
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    self.activityIndicator.isHidden = false
                } else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.activityIndicator.isHidden = true
                    
                    if self.data.foodYoutubeURL == "" {
                        self.noData.isHidden = false
                    }
                }
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
