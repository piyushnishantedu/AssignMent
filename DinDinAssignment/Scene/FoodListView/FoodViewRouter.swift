//
//  FoodViewRouter.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 19/07/21.
//

import Foundation
import UIKit

final class FoodViewRouter {
    
    func navigateToCart(with source: UIViewController) {
        let storyBoard = UIStoryboard(name: "Cart", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "CartViewController") as? CartViewController
        let dependencies = (
            interactor: CartViewInteractor(),
            router: CartViewRouter()
        )
        let presenter = CartViewPresenter(dependencies: dependencies)
        vc?.cartViewPresenter = presenter
        source.navigationController?.pushViewController(vc!, animated: true)
    }
}
