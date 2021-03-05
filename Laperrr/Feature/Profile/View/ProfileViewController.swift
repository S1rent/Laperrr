//
//  ProfileViewController.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var educationStackView: UIStackView!
    @IBOutlet weak var educationInitView: UIView!
    @IBOutlet weak var workingExperienceStackView: UIStackView!
    @IBOutlet weak var workingExperienceInitView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    let viewModel: ProfileViewModel
    let loadRelay: BehaviorRelay<Void>
    let disposeBag: DisposeBag
    var gradientLayer: CAGradientLayer?
    
    init() {
        self.viewModel = ProfileViewModel()
        self.loadRelay = BehaviorRelay<Void>(value: ())
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer?.frame = self.gradientView.layer.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        self.setupView()
        self.bindUI()
        self.setupGradient()
    }

    private func bindUI() {
        let output = self.viewModel.transform(input: ProfileViewModel.Input(loadTrigger: self.loadRelay.asDriver()
        ))
        
        self.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                self?.setupData(data)
            })
        )
    }
    
    private func setupData(_ data: ProfileModel) {
        self.imageProfile.image = data.picture
        self.labelName.text = data.name
        self.labelEmail.text = data.email
        
        self.setupStackViewData(stackView: self.educationStackView, experienceList: data.educationList)
        self.setupStackViewData(stackView: self.workingExperienceStackView, experienceList: data.workingExperienceList)
    }
    
    private func setupStackViewData(stackView: UIStackView, experienceList: [Experience]) {
        
        for (index, experience) in experienceList.enumerated() {
            let profileItem = ProfileItemView()
            
            profileItem.labelDuration.text = experience.timeSpan
            profileItem.labelDescription.text = experience.institutionName
            
            stackView.addArrangedSubview(profileItem)
            
            if index != experienceList.count-1 {
                let separatorView = addSeparatorView()
                
                stackView.addArrangedSubview(separatorView)
                separatorView.snp.makeConstraints { make in
                    make.height.equalTo(0.75)
                    make.leading.equalToSuperview().offset(8)
                    make.trailing.equalToSuperview().offset(-8)
                }
            }
        }
    }
    
    private func setupView() {
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.width / 2
        
        self.workingExperienceStackView.safelyRemoveAllArrangedSubviews()
        self.educationStackView.safelyRemoveAllArrangedSubviews()
        
        self.workingExperienceStackView.layer.cornerRadius = 6
        self.workingExperienceStackView.layer.borderColor = UIColor.lightGray.cgColor
        self.workingExperienceStackView.layer.borderWidth = 0.5
        
        self.educationStackView.layer.cornerRadius = 6
        self.educationStackView.layer.borderColor = UIColor.lightGray.cgColor
        self.educationStackView.layer.borderWidth = 0.5
    }
    
    private func setupGradient() {
        self.gradientView.layer.masksToBounds = true
        self.gradientLayer = self.gradientView.setGradientBackground(colorOne:  #colorLiteral(red: 0.1345393062, green: 0.1337468028, blue: 0.1351532042, alpha: 1), colorTwo:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    private func addSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        return view
    }
}
