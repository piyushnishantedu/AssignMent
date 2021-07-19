//
//  HomeViewPresentable.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 15/07/21.
//

import Foundation
import RxSwift
import RxCocoa

final class DashboardPresenter: DasboardPresenterInterface, DashBoardPresenterInput, DashBoardPresenterOutPut {
    var input: DashBoardPresenterInput { return self }
    var output: DashBoardPresenterOutPut { return self }
    
    // Input
    let viewDidLoadTrigger: PublishSubject<Void> = PublishSubject<Void>()
    let foodCategoryTrigger: PublishSubject<String> = PublishSubject<String>()
    
    // Output
    let bannerList: PublishRelay<[BannerPresentableData]>
    let foodList: PublishRelay<[FoodItem]>
    
    let isLoading: BehaviorRelay<Bool>
    let error: BehaviorRelay<Error?>
    
    private let dependencies: DashBoardPresenterDependencies
    private let disposeBag = DisposeBag()
    
    
    init(dependencies: DashBoardPresenterDependencies ) {
        self.dependencies = dependencies
        isLoading = dependencies.interactor.isLoading
        error = dependencies.interactor.errorRelay
        
        bannerList = PublishRelay<[BannerPresentableData]>()
        foodList = PublishRelay<[FoodItem]>()
        
        dependencies.interactor.bannerList.asDriver(onErrorJustReturn: []).drive { [weak self] (banners) in
            let bannerPrentableData = banners.map { BannerPresentableData(imageUrl: $0.bannerUrl) }
            self?.bannerList.accept(bannerPrentableData)
        }.disposed(by: disposeBag)

        
        viewDidLoadTrigger.asObservable().subscribe { [weak self] _ in
            self?.dependencies.interactor.getBannerList()
        }.disposed(by: disposeBag)
    }
    
}
