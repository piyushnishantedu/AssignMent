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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        let url = URL(string: "https://cdn.stocksnap.io/img-thumbs/960w/corn-sausage_XLQHKJKZSG.jpg")
        itemImageView.kf.setImage(with:url)
    }
}
