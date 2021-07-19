//
//  API.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 17/07/21.
//

import Foundation
import RxSwift
import RxMoya
import Moya
import ObjectMapper

//protocol NetworkClientType {
////    func request<Response: ImmutableMappable, target: TargetType>(_ provider: MoyaProvider<target>) -> Single<Response>
//    func request<Response, target: TargetType>(_ provider: MoyaProvider<target>) -> Single<GenericResponse<[Response]>>
//}
//
//class NetworkClient: NetworkClientType {
//    func request<Response, target>(_ provider: MoyaProvider<target>) -> Single<GenericResponse<[Response]>> where target : TargetType {
//        return provider.rx.request(target.self as! target).mapObject(type: GenericResponse<Response>)
//    }
//
//}

//struct GenericResponse<T: Mappable>: Mappable {
//    init?(map: Map) {
//
//    }
//    var code : Int? //Status code
//    var message: String = "" //message
//    var data:T? //data
//
//
//
//    init(code:Int,message:String,data:T?) {
//        self.code = code
//        self.message = message
//        self.data = data
//    }
//
//    mutating func mapping(map: Map) {
//        code <- map["code"]
//        message <- map["msg"]
//        data <- map["data"]
//    }
//}
