//
//  Banner.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 17/07/21.
//

import Foundation
import ObjectMapper

struct Banner: Mappable {
    init?(map: Map) {
        
    }
    var bannerUrl: String?
    mutating func mapping(map: Map) {
        bannerUrl <- map["url"]
    }
}
