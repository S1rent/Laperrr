//
//  FoodTarget.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import Moya

internal enum FoodTarget {
    case getRandomFood
    case getSearchedFood(text: String)
    case getFoodDetailByID(id: String)
    case getFoodCategories
    case getFoodListByCategories(category: String)
}

extension FoodTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.themealdb.com/")!
    }
    
    var path: String {
        switch self {
            case .getRandomFood:
                return "api/json/v1/1/random.php"
            case .getSearchedFood:
                return "api/json/v1/1/search.php"
            case .getFoodDetailByID:
                return "api/json/v1/1/lookup.php"
            case .getFoodCategories:
                return "api/json/v1/1/categories.php"
            case .getFoodListByCategories:
                return "api/json/v1/1/filter.php"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
            case .getRandomFood, .getFoodCategories:
                return nil
            case let .getSearchedFood(text):
                return [
                    "s": text
                ]
            case let .getFoodDetailByID(id):
                return [
                    "i": id
                ]
            case let .getFoodListByCategories(category):
                return [
                    "c": category
                ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var method: Moya.Method {
        switch self {
            default:
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
