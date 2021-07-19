//
//  CartNetworkManager.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 18/07/21.
//

import Foundation
import RxSwift
import RxMoya
import Moya

protocol CartServiceManagerType {
//    func getItemList() -> Single<Result<Banner>?>
    func getCartItems() -> Single<Result<CartItem>?>
}

struct CartNetworkManager: CartServiceManagerType {
    
    private let provider: MoyaProvider<CartService>
    
    init(with provider: MoyaProvider<CartService>) {
        self.provider = provider
    }
    
    func getCartItems() -> Single<Result<CartItem>?> {
        return provider.rx.request(.getCart).mapObject(type: Result<CartItem>.self)
    }
}
