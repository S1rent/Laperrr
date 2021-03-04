//
//  HomeNetworkProvider.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

final class HomeNetworkProvider {
    public static let shared = HomeNetworkProvider()
    
    private init() {}
    private let provider = MoyaProvider<HomeTarget>()
    
    public func getRandomFood() -> Observable<[Food]> {
        
        let requestToken = HomeTarget.getRandomFood
        
        return self.provider.rx
            .request(requestToken)
            .filterSuccessfulStatusCodes()
            .map(HomeResponseWrapper.self)
            .map { $0.data ?? [] }
            .asObservable()
    }
    
}
