//
//  CouponSponsoringTVC.swift
//  LifePlus
//
//  Created by Javu on 6/28/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class CouponSponsoringTVC: UITableViewCell {

    @IBOutlet weak var couponSponsoringImage: UIImageView!
    @IBOutlet weak var campaignNameLabel:   UILabel!
    @IBOutlet weak var merchantNameLabel:   UILabel!
    @IBOutlet weak var viewsLabel:          UILabel!
    @IBOutlet weak var rewardAmountLabel:   UILabel!

    var coupon: Campaign! {
        didSet{
            self.couponSponsoringImage.sd_setImage(with: URL(string: coupon.Banner!), placeholderImage: UIImage(named:"defaultImage"))
            self.campaignNameLabel.text = coupon.Name ?? ""
            if let view = self.coupon.View,
                let reward = self.coupon.RewardAmount {
                self.viewsLabel.text = "\(view)"
                self.rewardAmountLabel.text = "\(reward)"
            }
        }
    }
    var merchantName: String! {
        didSet{
            self.merchantNameLabel.text = merchantName ?? ""
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
