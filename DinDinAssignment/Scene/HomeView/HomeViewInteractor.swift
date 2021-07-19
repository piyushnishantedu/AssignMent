//
//  HomeViewInteractor.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 15/07/21.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import RxMoya

final class HomeViewInteractor {
    private let provider = MoyaProvider<DashBoardService>(stubClosure: MoyaProvider.immediatelyStub)
    private let service: DashboardServiceManager
    
    let bannerList = PublishRelay<[Banner]>()
    private let disposeBag = DisposeBag()
    
    let isLoading: BehaviorRelay<Bool>
    let errorRelay: BehaviorRelay<Error?>
    
    init() {
        isLoading = BehaviorRelay<Bool>(value: false)
        errorRelay = BehaviorRelay<Error?>(value: nil)
        service = DashboardServiceManager(with: provider)
    }
    
    func getBannerList()  {
         service.getBanners().subscribe { [weak self] (response) in
            self?.bannerList.accept(response?.dataArray ?? [])
        } onError: { [weak self] (error) in
            print(error)
            self?.errorRelay.accept(error)
        }.disposed(by: disposeBag)
    }
    
    
}
