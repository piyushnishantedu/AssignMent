//
//  FoodListViewController.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 15/07/21.
//

import UIKit
import RxMoya
import RxSwift
import RxCocoa

fileprivate enum FoodCategoryType: Int {
    case pizza =  0
    case sushi, drinks, none
}

class FoodListViewController: UIViewController, NavigationBarAppearance {

    @IBOutlet weak var foodMenuView: UIView!
    @IBOutlet weak var pizzaButton: UIButton!
    @IBOutlet weak var sushiButton: UIButton!
    @IBOutlet weak var drinksButton: UIButton!
    
    @IBOutlet weak var itemListView: UITableView!
    private var currentSelectedType = FoodCategoryType.none
    private let bag = DisposeBag()
    
    private let foodItems = PublishRelay<[FoodItem]>()
    
    @IBOutlet weak var cartButton: CartButton!
    
    
    var foodPresenter: FoodViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        view.roundCorners([.topLeft, .topRight], radius: 20)
        foodPresenter.output.foodItem.bind(to: foodItems).disposed(by: bag)
        configureView()
        foodPresenter.input.viewDidLoadTrigger.accept(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cartButton.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(isHidden: true)
    }
    
    private func configureView() {
        foodPresenter.addToCartAction.asDriver(onErrorJustReturn: -10).drive { [weak self] (index) in
            guard let self = self, let item = Int(self.cartButton.badge ?? "0"), let ind = index else { return }
            self.cartButton.badge = "\(item + 1)"
        }.disposed(by: self.bag)

        cartButton.rx.tap.asDriver().drive { [weak self] (_) in
            guard let self = self else { return }
            self.foodPresenter.dependencies.router.navigateToCart(with: self)
        }.disposed(by: bag)

        
        pizzaButton.setTitle(Constant.FoodListViewController.ButtonTitle.pizza.rawValue, for: .normal)
        sushiButton.setTitle(Constant.FoodListViewController.ButtonTitle.sushi.rawValue, for: .normal)
        drinksButton.setTitle(Constant.FoodListViewController.ButtonTitle.drinks.rawValue, for: .normal)
        pizzaButton.tag = FoodCategoryType.pizza.rawValue
        sushiButton.tag = FoodCategoryType.sushi.rawValue
        drinksButton.tag = FoodCategoryType.drinks.rawValue
        pizzaButton.setTitleColor(.gray, for: .normal)
        sushiButton.setTitleColor(.gray, for: .normal)
        drinksButton.setTitleColor(.gray, for: .normal)
        
        pizzaButton.titleLabel?.font = UIFont.bold(of: 30)
        sushiButton.titleLabel?.font = UIFont.bold(of: 30)
        drinksButton.titleLabel?.font = UIFont.bold(of: 30)
        setUpButton()
        setUpListView()
    }
    
    private func setUpButton() {
        pizzaButton.rx.tap.asDriver().drive { [weak self] _ in
            self?.updateButton(with: .pizza)
        }.disposed(by: bag)
        
        sushiButton.rx.tap.asDriver().drive { [weak self] _ in
            self?.updateButton(with: .sushi)
        }.disposed(by: bag)
        
        drinksButton.rx.tap.asDriver().drive { [weak self] _ in
            self?.updateButton(with: .drinks)
        }.disposed(by: bag)
    }
    
    private func setUpListView() {
        itemListView.register(UINib(nibName: Constant.FoodListViewController.CellIdentifier.foodItemTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: Constant.FoodListViewController.CellIdentifier.foodItemTableViewCell.rawValue)
        
        itemListView.rowHeight = UITableView.automaticDimension
        itemListView.estimatedRowHeight = 44
        itemListView.separatorStyle = .none
        
        foodItems.bind(to: itemListView.rx.items(cellIdentifier: Constant.FoodListViewController.CellIdentifier.foodItemTableViewCell.rawValue)) { row, model, cell in
            guard let itemCell = cell as? FoodItemTableViewCell else { return }
            itemCell.updateCell(with: model, tag: row)
            itemCell.addItemAction.bind(to: self.foodPresenter.addToCartAction).disposed(by: itemCell.bag)
        }.disposed(by: bag)
    }
    
    private func updateButton(with tag: FoodCategoryType) {
        currentSelectedType = tag
        let pizzaTag = FoodCategoryType(rawValue: pizzaButton.tag)
        let sushiTag = FoodCategoryType(rawValue: sushiButton.tag)
        let drinkTag = FoodCategoryType(rawValue: drinksButton.tag)
        pizzaButton.setTitleColor(currentSelectedType == pizzaTag ? .black : .gray, for: .normal)
        sushiButton.setTitleColor(currentSelectedType == sushiTag ? .black : .gray, for: .normal)
        drinksButton.setTitleColor(currentSelectedType == drinkTag ? .black : .gray, for: .normal)
    }
}
