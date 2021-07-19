//
//  BannerCollectionViewCell.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 16/07/21.
//

import UIKit
import Kingfisher

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var reuseIdentifier: String? { "BannerCollectionViewCell" }
    
    func updateImageView(with imageUrl: String) {
        let url = URL(string: imageUrl)
        bannerImageView.kf.setImage(with: url)
    }

}
