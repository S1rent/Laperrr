//
//  FoodCategoriesResponseWrapper.swift
//  Laperrr
//
//  Created by IT Division on 07/03/21.
//

import Foundation

public struct FoodCategoriesResponseWrapper: Decodable {
    let data: [FoodCategory]?
    
    internal enum CodingKeys: String, CodingKey {
        case data = "categories"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.data = try values.decodeIfPresent([FoodCategory].self, forKey: .data)
    }
}

public struct FoodCategory: Decodable {
    let categoryName: String?
    
    internal enum CodingKeys: String, CodingKey {
        case categoryName = "strCategory"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
    }
}
