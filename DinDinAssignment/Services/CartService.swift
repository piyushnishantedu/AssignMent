//
//  CartService.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 18/07/21.
//

import Foundation
import Moya

enum CartService {
    case getCart
}

extension CartService: TargetType {
    var baseURL: URL {
        return URL(string: "test.com")!
    }
    
    var path: String {
        switch self {
        case .getCart:
            return "/cart"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCart:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getCart:
            return getMockData(with: self, fileName: "cartData")
        }
    }
    
    var task: Task {
        .requestPlain
    }
    
    var headers: [String : String]? {
        ["Content-type": "application/json"]
    }
}

// MARK:- Extension for Mocked data
extension CartService {
    private func getMockData(with type: CartService, fileName: String) -> Data {
        switch type {
        case .getCart:
            if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    return data
                } catch {
                    print("Reading Erro in Mock Data of file \(fileName).json")
                    return Data()
                }
            } else {
                return Data()
            }
        }
    }
}
