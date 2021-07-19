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
//    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, CellModel>>!
    var cartSections = PublishRelay<[SectionModel<String, CellModel>]>()
    var totalPrice = ""
    
    //Output
    var cartItemList: PublishRelay<[CartItem]>
    
    let isLoading: BehaviorRelay<Bool>
    let error: BehaviorRelay<Error?>
    
    private let dependencies: CartViewPresenterDependencies
    private let bag = DisposeBag()
    
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
    }
    
    private func configureTableViewDataSource() {
//        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CellModel>>(configureCell: { [weak self]  dataSource, tableView, indexPath, item in
//            guard let self = self else { return  UITableViewCell() }
//            switch item {
//            case .cartCell(let cartItem):
//                return self.getCartItemCell(with: cartItem, from: tableView, indexPath: indexPath)
//            case .totalPriceCell:
//                return self.getTotalPriceCell(from: tableView, indexPath: indexPath)
//            }
//        })
        
//        cartSections.asObservable()
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//           .disposed(by: bag)
        
        self.cartItemList.asDriver(onErrorJustReturn: []).drive { [weak self] (cartItems) in
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
