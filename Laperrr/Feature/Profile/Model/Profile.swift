//
//  ProfileModel.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import Foundation
import UIKit

public struct ProfileModel {
    let name: String
    let email: String
    let picture: UIImage
    let educationList: [Experience]
    let workingExperienceList: [Experience]
    
    public init(name: String, email: String, picture: UIImage, educationList: [Experience], workingExperienceList: [Experience]) {
        self.name = name
        self.email = email
        self.educationList = educationList
        self.workingExperienceList = workingExperienceList
        self.picture = picture
    }
}

public struct Experience {
    let timeSpan: String
    let institutionName: String
    
    public init(timeSpan: String, institutionName: String) {
        self.timeSpan = timeSpan
        self.institutionName = institutionName
    }
}

class Profile {
    static let shared = Profile()
    public init() { }
    
    public func makeExperienceModel(timeSpan: String, institutionName: String) -> Experience {
        let model = Experience(timeSpan: timeSpan, institutionName: institutionName)
        
        return model
    }
    
    public func makeProfileModel(name: String, email: String, picture: UIImage, educationList: [Experience], workingExperienceList: [Experience]) -> ProfileModel {
        let model = ProfileModel(name: name, email: email, picture: picture, educationList: educationList, workingExperienceList: workingExperienceList)
        
        return model
    }
}
