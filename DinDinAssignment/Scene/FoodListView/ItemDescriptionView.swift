//
//  ItemDescriptionView.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 18/07/21.
//

import UIKit
import RxSwift
import RxCocoa

class ItemDescriptionView: UIView {

    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weightInfoLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    var addItemAction = PublishRelay<Int?>()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    

    
    private func configureView() {
        titleLabel.font = UIFont.bold(of: 20)
        descriptionLabel.font = UIFont.regular(of: 17)
        titleLabel.textColor = .black
        descriptionLabel.textColor = .gray
        priceButton.roundCorners(.allCorners, radius: 20)
        priceButton.setTitle("46 usd", for: .normal)
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.backgroundColor = .black
        weightInfoLabel.font = UIFont.regular(of: 14)
        weightInfoLabel.textColor = .gray

    }
    
    func setUpView() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)
        configureView()
    }
    
    func update(with foodItem: FoodItem, tag: Int) {
        titleLabel.text = foodItem.name
        descriptionLabel.text = foodItem.description
        let foodPrice = foodItem.price ?? ""
        priceButton.setTitle(foodPrice.getFormattedPrice(with: Constant.ItemCell.currency), for: .normal)
        weightInfoLabel.text = foodItem.weightDetails
        priceButton.tag = tag
    }
    
    @IBAction private func addAction(_ sender: UIButton) {
        addItemAction.accept(sender.tag)
        let title = sender.titleLabel?.text ?? ""
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.priceButton.backgroundColor = .green
            self?.priceButton.setTitle(Constant.ItemCell.addOne, for: .normal)
        } completion: { [weak self] (isComplete) in
            if isComplete {
                self?.priceButton.backgroundColor = .black
                self?.priceButton.setTitle(title, for: .normal)
            }
        }

    }
    
}
