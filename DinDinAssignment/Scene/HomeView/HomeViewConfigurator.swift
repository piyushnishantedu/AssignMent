//
//  HomeViewConfigurator.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 15/07/21.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

typealias DashBoardPresenterDependencies = (
    interactor: HomeViewInteractor,
    router: HomeRouter
)

protocol DashBoardPresenterInput {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var foodCategoryTrigger: PublishSubject<String> { get }
}

protocol DashBoardPresenterOutPut {
    var bannerList: PublishRelay<[BannerPresentableData]> { get }
    var foodList: PublishRelay<[FoodItem]> { get }
}

protocol DasboardPresenterInterface {
    var input: DashBoardPresenterInput { get }
    var output: DashBoardPresenterOutPut { get }
}

final class HomeViewConfigurator {
    func launchHomeview(window: UIWindow?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController = storyBoard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        
        let dependencies = (
            interactor: HomeViewInteractor(),
            router: HomeRouter()
        )
        homeViewController.homeViewPresenter = DashboardPresenter(dependencies: dependencies)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        window?.rootViewController = navigationController
    }
}
