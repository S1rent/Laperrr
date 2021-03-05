//
//  FoodListResponseWrapper.swift
//  Laperrr
//
//  Created by IT Division on 04/03/21.
//

import Foundation

public struct FoodListResponseWrapper: Decodable {
    let data: [Food]?
    
    internal enum CodingKeys: String, CodingKey {
        case data = "meals"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.data = try values.decodeIfPresent([Food].self, forKey: .data)
    }
}

public struct Food: Decodable {
    let foodID: String?
    let foodName: String?
    let foodCategory: String?
    let foodOrigin: String?
    let foodImageURL: String?
    
    internal enum CodingKeys: String, CodingKey {
        case foodID = "idMeal"
        case foodname = "strMeal"
        case foodCategory = "strCategory"
        case foodOrigin = "strArea"
        case foodImageURL = "strMealThumb"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.foodID = try values.decodeIfPresent(String.self, forKey: .foodID)
        self.foodName = try values.decodeIfPresent(String.self, forKey: .foodname)
        self.foodCategory = try values.decodeIfPresent(String.self, forKey: .foodCategory)
        self.foodOrigin = try values.decodeIfPresent(String.self, forKey: .foodOrigin)
        self.foodImageURL = try values.decodeIfPresent(String.self, forKey: .foodImageURL)
    }
}
