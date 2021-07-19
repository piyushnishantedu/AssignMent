//
//  FoodViewInteractor.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 19/07/21.
//

import Foundation
import Moya
import RxMoya
import RxCocoa
import RxSwift

final class FoodViewInteractor {
    private let provider = MoyaProvider<DashBoardService>(stubClosure: MoyaProvider.immediatelyStub)
    private let service: DashboardServiceManager
    let foodList = PublishRelay<[FoodItem]>()
    private let disposeBag = DisposeBag()
    let isLoading: BehaviorRelay<Bool>
    let errorRelay: BehaviorRelay<Error?>
    
    init() {
        isLoading = BehaviorRelay<Bool>(value: false)
        errorRelay = BehaviorRelay<Error?>(value: nil)
        service = DashboardServiceManager(with: provider)
    }
    
    func getFoodList()  {
         service.getFoodList().subscribe { [weak self] (response) in
            self?.foodList.accept(response?.dataArray ?? [])
        } onError: { [weak self] (error) in
            print(error)
            self?.errorRelay.accept(error)
        }.disposed(by: disposeBag)
    }
    
    
}
