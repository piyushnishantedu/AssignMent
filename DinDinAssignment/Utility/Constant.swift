//
//  Constant.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 18/07/21.
//

import Foundation

struct Constant {
    struct ItemCell {
        static let addOne = "Add + 1"
        static let currency = "Usd"
    }
    
    struct FoodListViewController {
        static let identifier = "FoodListViewController"
        enum ButtonTitle: String {
            case pizza = "Pizza"
            case sushi = "Sushi"
            case drinks = "Drinks"
        }
        enum CellIdentifier: String {
            case foodItemTableViewCell = "FoodItemTableViewCell"
        }
    }
    
    struct CartViewController {
        static let identifier = "CartViewController"
        enum ButtonTitle: String {
            case cart = "Cart"
            case order = "Order"
            case info = "Info"
        }
        enum CellIdentifier: String {
            case cartItemTableViewCell = "CartItemTableViewCell"
            case cartTotalTableViewCell = "CartTotalTableViewCell"
        }
    }
    
    enum storyBoardName: String {
        case main = "Main"
        case cart = "cart"
    }
}
