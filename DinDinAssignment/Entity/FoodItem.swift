//
//  FoodItem.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 17/07/21.
//

import Foundation
import ObjectMapper

struct FoodItem: Mappable {
    var name: String?
    var imageUrl: String?
    var description: String?
    var price: String?
    var weightDetails: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        description <- map["description"]
        price <- map["price"]
        weightDetails <- map["weightDetails"]
    }
    
    init(name: String, imageUrl: String, description: String, price: String, weightDetail: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.description = description
        self.price = price
        self.weightDetails = weightDetail
    }
}
