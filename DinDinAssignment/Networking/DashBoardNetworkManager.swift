//
//  DashBoardNetworkManager.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 17/07/21.
//

import RxSwift
import Moya
import RxMoya
import ReactiveSwift


protocol DashboardServiceManagerType {
//    func getItemList() -> Single<Result<Banner>?>
    func getBanners() -> Single<Result<Banner>?>
    func getFoodList() -> Single<Result<FoodItem>?>
}

struct DashboardServiceManager: DashboardServiceManagerType {
    
    private let provider: MoyaProvider<DashBoardService>
    
    init(with provider: MoyaProvider<DashBoardService>) {
        self.provider = provider
    }
    
    func getBanners() -> Single<Result<Banner>?> {
        return provider.rx.request(.getBanner).mapObject(type: Result<Banner>.self)
    }
    
    func getFoodList() -> Single<Result<FoodItem>?> {
        return provider.rx.request(.getFoodList).mapObject(type: Result<FoodItem>.self)
    }
}
