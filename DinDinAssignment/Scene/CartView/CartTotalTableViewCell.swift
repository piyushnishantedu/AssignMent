//
//  CartTotalTableViewCell.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 18/07/21.
//

import UIKit

class CartTotalTableViewCell: UITableViewCell {
    @IBOutlet weak var deliveryInfoLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with total: String) {
        priceLabel.text = total.getFormattedPrice(with: Constant.ItemCell.currency)
    }
    
}
