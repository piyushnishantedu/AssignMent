//
//  FoodViewPresenter.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 19/07/21.
//

import Foundation
import RxCocoa
import RxSwift

final class FoodViewPresenter: FoodViewPresenterInterface, FoodViewPresenterInput, FoodViewPresenterOutPut {
    
    var input: FoodViewPresenterInput { self }
    var output: FoodViewPresenterOutPut { self }
    
    // INPUT
    var viewDidLoadTrigger: PublishRelay<Void>  = PublishRelay<Void>()
    var getFoodList: PublishRelay<Void>  = PublishRelay<Void>()
    var addToCartAction: PublishRelay<Int?>  = PublishRelay<Int?>()
    
    //OUTPUT
    var foodItem: PublishRelay<[FoodItem]>
    
    let isLoading: BehaviorRelay<Bool>
    let error: BehaviorRelay<Error?>
    
    let dependencies: FoodListViewPresenterDependencies
    private let bag = DisposeBag()
    
    init(dependencies: FoodListViewPresenterDependencies) {
        self.dependencies = dependencies
        isLoading = dependencies.interactor.isLoading
        error = dependencies.interactor.errorRelay
        foodItem = PublishRelay<[FoodItem]>()
        
        dependencies.interactor.foodList.asDriver(onErrorJustReturn: []).drive { [weak self] (foods) in
            self?.foodItem.accept(foods)
        }.disposed(by: bag)

        
        viewDidLoadTrigger.asObservable().subscribe { [weak self] _ in
            self?.dependencies.interactor.getFoodList()
        }.disposed(by: bag)
    }
    
}
