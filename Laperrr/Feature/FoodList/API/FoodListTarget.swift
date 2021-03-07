//
//  FoodListTarget.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import Moya

internal enum FoodListTarget{
    case getRandomFood
    case getSearchedFood(text: String)
}

extension FoodListTarget: TargetType{
    var baseURL: URL {
        return URL(string: "https://www.themealdb.com/")!
    }
    
    var path: String {
        switch self {
        case .getRandomFood:
            return "api/json/v1/1/random.php"
        case .getSearchedFood:
            return "api/json/v1/1/search.php"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
            case .getRandomFood:
                return nil
            case let .getSearchedFood(text):
                return [
                    "s": text
                ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var method: Moya.Method {
        switch self {
            case .getRandomFood, .getSearchedFood:
                return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
            default:
                return ["Content-Type": "application/json"]
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
    }
    
    var sampleData: Data {
        return "{\"data\": 123}".data(using: .utf8)!
    }
}
