//
//  CartViewPresenter.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 18/07/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import UIKit

final class CartViewPresenter: CartViewPresenterInterface, CartViewPresenterInput, CartViewPresenterOutPut {
    
    var input: CartViewPresenterInput { self }
    var output: CartViewPresenterOutPut { self }
    
    
    // Input
    var viewDidLoadTrigger: PublishRelay<Void> = PublishRelay<Void>()
    var getCartItem: PublishRelay<Void> = PublishRelay<Void>()
    var cartSections = PublishRelay<[SectionModel<String, CellModel>]>()
    var totalPrice = ""
    var cartItemRemoveAction: PublishRelay<Int?> = PublishRelay<Int?>()
    
    //Output
    var cartItemList: PublishRelay<[CartItem]>
    
    let isLoading: BehaviorRelay<Bool>
    let error: BehaviorRelay<Error?>
    
    private let dependencies: CartViewPresenterDependencies
    private let bag = DisposeBag()
    private var cartList = [CartItem]()
    
    init(dependencies: CartViewPresenterDependencies) {
        self.dependencies = dependencies
    
        isLoading = dependencies.interactor.isLoading
        error = dependencies.interactor.errorRelay
        
        cartItemList = PublishRelay<[CartItem]>()
        
        configureTableViewDataSource()
        
        dependencies.interactor.cartItemList.bind(to: self.cartItemList).disposed(by: bag)
        
        viewDidLoadTrigger.asDriver(onErrorJustReturn: ()).drive { [weak self] (_) in
            self?.dependencies.interactor.getCartItems()
        }.disposed(by: bag)
        
        cartItemRemoveAction.asDriver(onErrorJustReturn: -10).drive { [weak self] (index) in
            guard let self  = self, let row = index else  { return }
            self.cartList.remove(at: row)
            self.cartItemList.accept(self.cartList)
        }.disposed(by: bag)

    }
    
    private func configureTableViewDataSource() {
        self.cartItemList.asDriver(onErrorJustReturn: []).drive { [weak self] (cartItems) in
            self?.cartList = cartItems
            let priceData = cartItems.map { Int($0.price ?? "0") ?? 0}
            let price = priceData.reduce(0) { $0 + $1 }
            self?.totalPrice = "\(price)"
            let cellModels = cartItems.map { CellModel.cartCell($0) } + [CellModel.totalPriceCell]
            let sectionData = SectionModel(model: "", items: cellModels)
            self?.cartSections.accept([sectionData])
            
        }.disposed(by: bag)
    }
}

enum CellModel {
    case cartCell(CartItem)
    case totalPriceCell
}
