//
//  ProfileViewModel.swift
//  Laperrr
//
//  Created by IT Division on 05/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModel {
    public struct Input {
        let loadTrigger: Driver<Void>
    }
    
    public struct Output {
        let data: Driver<ProfileModel>
    }
    
    public func transform(input: Input) -> Output {
        let profileData = input.loadTrigger.flatMapLatest { _ -> Driver<ProfileModel> in
            
            let educationList: [Experience] = [
                Profile.shared.makeExperienceModel(timeSpan: "2008 - 2011", institutionName: "SD Pelita Kudus"),
                Profile.shared.makeExperienceModel(timeSpan: "2011 - 2013", institutionName: "SD Santo Yakobus"),
                Profile.shared.makeExperienceModel(timeSpan: "2013 - 2016", institutionName: "SMP Santo Yakobus"),
                Profile.shared.makeExperienceModel(timeSpan: "2016 - 2019", institutionName: "SMA Santo Yakobus"),
                Profile.shared.makeExperienceModel(timeSpan: "2019 - Present", institutionName: "BINUS University")
            ]
            
            let workingExperienceList: [Experience] = [
                Profile.shared.makeExperienceModel(timeSpan: "2019 - 2020", institutionName: "Education Counselour for BINUS University"),
                Profile.shared.makeExperienceModel(timeSpan: "2020 - 2021", institutionName: "Associate Member for BINUS IT Division"),
                Profile.shared.makeExperienceModel(timeSpan: "2021 - Present", institutionName: "Junior Programmer for BINUS IT Division")
            ]
            
            let profile: ProfileModel = Profile.shared.makeProfileModel(name: "Philip Indra Prayitno", email: "philip.prayitno@gmail.com", picture: #imageLiteral(resourceName: "img-profile"), educationList: educationList, workingExperienceList: workingExperienceList)
            
            return Driver.just(profile)
        }
        
        return Output(data: profileData)
    }
}
