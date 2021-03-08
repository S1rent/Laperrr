//
//  ProfileViewController.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var educationStackView: UIStackView!
    @IBOutlet weak var educationInitView: UIView!
    @IBOutlet weak var workingExperienceStackView: UIStackView!
    @IBOutlet weak var workingExperienceInitView: UIView!
    @IBOutlet weak var skillInitView: UIView!
    @IBOutlet weak var skillStackView: UIStackView!
    @IBOutlet weak var gradientView: UIView!
    
    let viewModel: ProfileViewModel
    let loadRelay: BehaviorRelay<Void>
    var gradientLayer: CAGradientLayer?
    
    init() {
        self.viewModel = ProfileViewModel()
        self.loadRelay = BehaviorRelay<Void>(value: ())
        
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
        self.setupGradient()
        
        self.bindUI()
    }

    private func bindUI() {
        let output = self.viewModel.transform(input: ProfileViewModel.Input(loadTrigger: self.loadRelay.asDriver()
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                self?.setupData(data)
            })
        )
    }
    
    private func setupData(_ data: ProfileModel) {
        self.imageProfile.image = data.picture
        self.labelName.text = data.name
        self.labelEmail.text = data.email
        
        self.setupExperienceStackViewData(stackView: self.educationStackView, experienceList: data.educationList)
        self.setupExperienceStackViewData(stackView: self.workingExperienceStackView, experienceList: data.workingExperienceList)
        self.setupSkillStackViewData(stackView: self.skillStackView, skills: data.skills)
    }
    
    private func setupExperienceStackViewData(stackView: UIStackView, experienceList: [Experience]) {
        
        for (index, experience) in experienceList.enumerated() {
            let experienceItem = ExperienceItemView()
            
            experienceItem.labelDuration.text = experience.timeSpan
            experienceItem.labelDescription.text = experience.institutionName
            
            stackView.addArrangedSubview(experienceItem)
            
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
    
    private func setupSkillStackViewData(stackView: UIStackView, skills: [Skill]) {

        for (index, skill) in skills.enumerated() {
            let skillItem = SkillItemView()
            
            skillItem.labelSkillName.text = skill.skillName
            skillItem.progressView.progress = Float(skill.progress / 100)
            
            stackView.addArrangedSubview(skillItem)
            
            if index != skills.count-1 {
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
        
        self.setupStackView(stackView: self.educationStackView)
        self.setupStackView(stackView: self.workingExperienceStackView)
        self.setupStackView(stackView: self.skillStackView)
    }
    
    private func setupStackView(stackView: UIStackView) {
        stackView.safelyRemoveAllArrangedSubviews()
        stackView.layer.cornerRadius = 6
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        
        stackView.alpha = 0
        UIView.animate(
            withDuration: 1.2,
            delay: 0.5,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.1,
            options: [.curveEaseInOut],
            animations: {
                stackView.alpha = 1
        })
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
