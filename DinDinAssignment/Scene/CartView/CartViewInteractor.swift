//
//  CartViewInteractor.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 18/07/21.
//

import Foundation
import RxMoya
import Moya
import RxSwift
import RxCocoa

final class CartViewInteractor {
    private let provide = MoyaProvider<CartService>(stubClosure: MoyaProvider.immediatelyStub)
    private let service: CartNetworkManager
    
    let cartItemList = PublishRelay<[CartItem]>()
    private let bag = DisposeBag()
    
    let isLoading: BehaviorRelay<Bool>
    let errorRelay: BehaviorRelay<Error?>
    
    init() {
        isLoading = BehaviorRelay<Bool>(value: false)
        errorRelay = BehaviorRelay<Error?>(value: nil)
        service = CartNetworkManager(with: provide)
    }
    
    func getCartItems() {
        service.getCartItems()
            .subscribe { [weak self] response in
            self?.cartItemList.accept(response?.dataArray ?? [])
        } onError: { [weak self] (error) in
            print(error)
            self?.errorRelay.accept(error)
        }.disposed(by: bag)
    }
}
