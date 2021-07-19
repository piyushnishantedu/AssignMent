//
//  CartItemTableViewCell.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 18/07/21.
//

import UIKit
import Kingfisher

class CartItemTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configure() {
        productNameLabel.font = UIFont.regular(of: 15)
        productPriceLabel.font = UIFont.regular(of: 15)
    }
    
    func update(with cartItem: CartItem) {
        let url = URL(string: cartItem.imageUrl ?? "")
        productImageView.kf.setImage(with: url)
        productNameLabel.text = cartItem.productName
        productPriceLabel.text = cartItem.price?.getFormattedPrice(with: "USD")
    }
    
}
