//
//  CategoryTarget.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation
import Moya

internal enum CategoryTarget {
    case getFoodCategories
    case getFoodListByCategories(category: String)
}

extension CategoryTarget: TargetType{
    var baseURL: URL {
        return URL(string: "https://www.themealdb.com/")!
    }
    
    var path: String {
        switch self {
            case .getFoodCategories:
                return "api/json/v1/1/categories.php"
            case .getFoodListByCategories:
                return "api/json/v1/1/filter.php"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
            case .getFoodCategories:
                return nil
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
            case .getFoodCategories, .getFoodListByCategories:
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
