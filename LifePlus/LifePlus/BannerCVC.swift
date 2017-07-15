//
//  BannerCVC.swift
//  LifePlus
//
//  Created by Javu on 6/9/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class BannerCVC: UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!

    var banner: String! {
        didSet{
            self.bannerImageView.sd_setImage(with: URL(string: banner))
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
