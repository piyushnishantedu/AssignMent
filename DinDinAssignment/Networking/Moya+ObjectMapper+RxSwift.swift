//
//  Moya+ObjectMapper+RxSwift.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 17/07/21.
//

import Foundation
//  MoyaRxSwiftObjectMapperExtension.swift

import Foundation
import RxSwift
import Moya
import ObjectMapper

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapObject<T: Mappable>(type: T.Type) -> Single<T?> {
        return self.map{ response in
            return try (response.mapObject(type: type))
        }
    }
    func mapArray<T: Mappable>(type: T.Type) -> Single<[T]> {
        return self.map{ response in
            return try response.mapArray(type: type)
        }
    }
}
public extension ObservableType where Element == Response {
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T?> {
        return self.map{ response in
            return try response.mapObject(type: type)
        }
    }
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map{ response in
            return try response.mapArray(type: type)
        }
    }
}

public extension Response{
    func mapObject<T: Mappable>(type: T.Type) throws -> T?{
        let text = String(bytes: self.data, encoding: .utf8)
        if self.statusCode < 400 {
            return Mapper<T>().map(JSONString: text!)
        }
        do{
            let serviceError = Mapper<ServiceError>().map(JSONString: text!)
            throw serviceError!
        }catch{
            if error is ServiceError {
                throw error
            }
            let serviceError = ServiceError()
                         serviceError.message = "server desertion, please try again later."
            serviceError.error_code = "parse_error"
            throw serviceError
        }
    }
    func mapArray<T: BaseMappable>(type: T.Type) throws -> [T]{
        let text = String(bytes: self.data, encoding: .utf8)
        if self.statusCode < 400 {
            return Mapper<T>().mapArray(JSONString: text!)!
        }
        do{
            let serviceError = Mapper<ServiceError>().map(JSONString: text!)
            throw serviceError!
        }catch{
            if error is ServiceError {
                throw error
            }
            let serviceError = ServiceError()
                         serviceError.message = "server desertion, please try again later."
            serviceError.error_code = "parse_error"
            throw serviceError
        }
    }
}
class ServiceError:Error,Mappable{
    var message:String = ""
    var error_code:String = ""
    required init?(map: Map) {}
    init() {
        
    }
    func mapping(map: Map) {
        error_code <- map["error_code"]
        message <- map["error"]
    }
    var localizedDescription: String{
        return message
    }
}


struct Result<T: Mappable>: Mappable {
    init?(map: Map) {
        
    }
    var data: T?
    var code: Int?
    var message: String?
    var dataArray: [T]?
 
    mutating func mapping(map: Map) {
        data <- map["data"]
        dataArray <- map["data"]
        code <- map["code"]
        message <- map["msg"]
    }
}
