//
//  FoodItemTableViewCell.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 18/07/21.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class FoodItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemDetailView: ItemDescriptionView!
    var bag = DisposeBag()
    var addItemAction = PublishRelay<Int?>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemDetailView.addItemAction.bind(to: addItemAction).disposed(by: bag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(with foodItem: FoodItem, tag: Int) {
        let url = URL(string: foodItem.imageUrl ?? "")
        itemImageView.kf.setImage(with:url)
        itemDetailView.update(with: foodItem,tag: tag)
    }
}
