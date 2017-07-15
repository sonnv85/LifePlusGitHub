//
//  GiftTVC.swift
//  LifePlus
//
//  Created by Javu on 7/6/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class ExchangePointTVC: UITableViewCell {

    @IBOutlet weak var merchantNameLabel:       UILabel!
    @IBOutlet weak var merchantAddressLabel:    UILabel!
    @IBOutlet weak var logoMerchantButton:      UIButton!

    @IBOutlet weak var totalGiftLabel: UILabel!
    var merchant: Merchant! {
        didSet{
            self.merchantNameLabel.text     = merchant.MerchantName
            self.merchantAddressLabel.text  = merchant.Address
            self.logoMerchantButton.circleButton()
            self.logoMerchantButton.sd_setImage(with: URL(string:merchant.MerchantLogo!), for: .normal, placeholderImage: UIImage(named: "defaultImage"))
            // self.logoMerchantButton.sd_setImage(with: URL(string:merchant.MerchantLogo!), for: .normal)
            self.totalGiftLabel.text = "\(merchant.TotalCampaignGift ?? 0)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
