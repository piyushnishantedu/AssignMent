//
//  FoodViewConfigurator.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 19/07/21.
//

import Foundation
import RxMoya
import RxSwift
import RxCocoa
import UIKit

// FOOD LIST
typealias FoodListViewPresenterDependencies = (
    interactor: FoodViewInteractor,
    router: FoodViewRouter
)

protocol FoodViewPresenterInput {
    var viewDidLoadTrigger: PublishRelay<Void> {  get }
    var getFoodList: PublishRelay<Void> { get }
    var addToCartAction: PublishRelay<Int?> { get }
}

protocol FoodViewPresenterOutPut {
    var foodItem: PublishRelay<[FoodItem]> { get }
}

protocol FoodViewPresenterInterface {
    var input: FoodViewPresenterInput { get }
    var output: FoodViewPresenterOutPut { get }
}

final class FoodListConfigurator {
    func getFoodListViewController() -> FoodListViewController {
        let dep = (interactor: FoodViewInteractor(), router: FoodViewRouter())
        let foodPresenter = FoodViewPresenter(dependencies: dep)
        let storyBoard = UIStoryboard(name: Constant.storyBoardName.main.rawValue, bundle: nil)
        let foodView = storyBoard.instantiateViewController(withIdentifier: Constant.FoodListViewController.identifier) as! FoodListViewController
        foodView.foodPresenter = foodPresenter
        return foodView
    }
}
