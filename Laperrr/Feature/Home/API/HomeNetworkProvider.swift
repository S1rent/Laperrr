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

class HomeNetworkProvider {
    
    private let provider = MoyaProvider<HomeTarget>(plugins: [NetworkLoggerPlugin()])
    public static let shared = HomeNetworkProvider()
    private init() {}
    
    public func getRandomFood() -> Observable<[Food]> {
        let requestToken = HomeTarget.getRandomFood
        
        return self.provider.rx
            .request(requestToken)
            .map(HomeResponseWrapper.self)
            .map { $0.data ?? [] }
            .do(onNext: { res in
                print(res)
            })
            .asObservable()
    }
    
}
