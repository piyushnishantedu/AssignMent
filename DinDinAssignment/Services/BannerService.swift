//
//  BannerService.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 17/07/21.
//

import Foundation
import Moya

enum DashBoardService {
    case getBanner
    case getFoodList
}

extension DashBoardService: TargetType {
    var baseURL: URL {
        return URL(string: "test.com")!
    }
    
    var path: String {
        switch self {
        case .getBanner:
            return "/banner"
        case .getFoodList:
            return "/foodlist"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBanner, .getFoodList:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getBanner:
            return getMockData(with: self, fileName: "banner")
        case .getFoodList:
            return getMockData(with: self, fileName: "food")
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
extension DashBoardService {
    private func getMockData(with type: DashBoardService, fileName: String) -> Data {
        switch type {
        case .getBanner, .getFoodList:
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
        default:
            return Data()
        }
    }
}
