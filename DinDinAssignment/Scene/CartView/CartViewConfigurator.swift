//
//  CartViewConfigurator.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 18/07/21.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import UIKit

typealias CartViewPresenterDependencies = (
    interactor: CartViewInteractor,
    router: CartViewRouter
)

protocol CartViewPresenterInput {
    var viewDidLoadTrigger: PublishRelay<Void> {  get }
    var getCartItem: PublishRelay<Void> { get }
    var cartSections: PublishRelay<[SectionModel<String, CellModel>]> { get }
}

protocol CartViewPresenterOutPut {
    var cartItemList: PublishRelay<[CartItem]> { get }
    var totalPrice: String { get }
}

protocol CartViewPresenterInterface {
    var input: CartViewPresenterInput { get }
    var output: CartViewPresenterOutPut { get }
}
