//
//  SkillItemView.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import UIKit

class SkillItemView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelSkillName: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.bindNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindNib() {
        Bundle.main.loadNibNamed(SkillItemView.identifier, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.layer.masksToBounds = true
        
        self.setupView()
    }
    
    private func setupView() {
        self.roundedView.layer.cornerRadius = self.roundedView.frame.width / 2
        self.progressView.layer.cornerRadius = 6
    }
}
