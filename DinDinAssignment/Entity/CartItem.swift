//
//  CartItem.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 18/07/21.
//

import Foundation
import ObjectMapper

struct CartItem: Mappable {
    var imageUrl: String?
    var productName: String?
    var price: String?
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        imageUrl <- map["url"]
        productName <- map["name"]
        price <- map["price"]
    }
    
    init(imageUrl: String, productName: String, price: String) {
        self.imageUrl = imageUrl
        self.imageUrl = imageUrl
        self.price = price
    }
    
}
