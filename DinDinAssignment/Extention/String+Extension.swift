//
//  String+Extension.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 17/07/21.
//

import Foundation

extension String {
    var dataEncoded: Data? {
        return self.data(using: .utf8)
    }
    
    func getFormattedPrice(with currency: String) -> String {
        return self + " \(currency)"
    }
}
