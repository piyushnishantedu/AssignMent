//
//  CartViewController.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 16/07/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


fileprivate enum Option: Int {
    case cart = 0
    case order, information, none
}

class CartViewController: UIViewController, NavigationBarAppearance {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var informationButton: UIButton!
    
    let bag = DisposeBag()
    private var selectedType = Option.none
    
    @IBOutlet weak var cartItemTableView: UITableView!
    
    
    var cartViewPresenter: CartViewPresenterInterface!
//    private let cartItems = PublishRelay<[CartItem]>()
    private let cartSections = PublishRelay<[SectionModel<String, CellModel>]>()
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, CellModel>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideNavigationBar(isHidden: false)
        cartViewPresenter.input.cartSections.bind(to: cartSections).disposed(by: bag)
        configureView()
        
        cartViewPresenter.input.viewDidLoadTrigger.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(isHidden: false)
        navigationController?.navigationBar.backItem?.backBarButtonItem?.title = "Menu"
    }
    
    private func configureView() {
        cartButton.setTitle("Cart", for: .normal)
        orderButton.setTitle("Order", for: .normal)
        informationButton.setTitle("Info", for: .normal)
        cartButton.tag = Option.cart.rawValue
        orderButton.tag = Option.order.rawValue
        informationButton.tag = Option.information.rawValue
        cartButton.setTitleColor(.gray, for: .normal)
        orderButton.setTitleColor(.gray, for: .normal)
        informationButton.setTitleColor(.gray, for: .normal)
        
        cartButton.titleLabel?.font = UIFont.bold(of: 30)
        orderButton.titleLabel?.font = UIFont.bold(of: 30)
        informationButton.titleLabel?.font = UIFont.bold(of: 30)
        setUpButton()
        cartItemSetup()
        configureTableViewDataSource()
        cartSections.asObservable()
            .bind(to: cartItemTableView.rx.items(dataSource: dataSource))
           .disposed(by: bag)
        
//        cartViewPresenter.output.cartItemList.asDriver(onErrorJustReturn: []).drive { [weak self] (cartItems) in
//            self?.cartItems.accept(cartItems)
//        }.disposed(by: bag)

    }
    
    private func getCartItemCell(with cartItem: CartItem, from table: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "CartItemTableViewCell", for: indexPath) as? CartItemTableViewCell
        cell?.update(with: cartItem)
        return cell ?? UITableViewCell()
    }
    
    private func getTotalPriceCell(from table: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "CartTotalTableViewCell", for: indexPath) as? CartTotalTableViewCell
        cell?.update(with: cartViewPresenter.output.totalPrice)
        return cell ?? UITableViewCell()
    }
    
    private func configureTableViewDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CellModel>>(configureCell: { dataSource, tableView, indexPath, item in
           switch item {
           case .cartCell(let cartItem):
               return self.getCartItemCell(with: cartItem, from: tableView, indexPath: indexPath)
           case .totalPriceCell:
               return self.getTotalPriceCell(from: tableView, indexPath: indexPath)
           }
       })
    }
    
    
    private func cartItemSetup() {
        cartItemTableView.register(UINib(nibName: "CartItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CartItemTableViewCell")
        cartItemTableView.register(UINib(nibName: "CartTotalTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTotalTableViewCell")
        
        cartItemTableView.rowHeight = UITableView.automaticDimension
        cartItemTableView.estimatedRowHeight = 44
        cartItemTableView.separatorStyle = .none
        
    }
    
    private func setUpButton() {
        cartButton.rx.tap.asDriver().drive { [weak self] _ in
            self?.updateButton(with: .cart)
        }.disposed(by: bag)
        
        orderButton.rx.tap.asDriver().drive { [weak self] _ in
            self?.updateButton(with: .order)
        }.disposed(by: bag)
        
        informationButton.rx.tap.asDriver().drive { [weak self] _ in
            self?.updateButton(with: .information)
        }.disposed(by: bag)
    }
    
    private func updateButton(with tag: Option) {
        selectedType = tag
        let cartButtonTag = Option(rawValue: cartButton.tag)
        let orderButtonTag = Option(rawValue: orderButton.tag)
        let informationButtonTag = Option(rawValue: informationButton.tag)
        cartButton.setTitleColor(selectedType == cartButtonTag ? .black : .gray, for: .normal)
        orderButton.setTitleColor(selectedType == orderButtonTag ? .black : .gray, for: .normal)
        informationButton.setTitleColor(selectedType == informationButtonTag ? .black : .gray, for: .normal)
    }

}

