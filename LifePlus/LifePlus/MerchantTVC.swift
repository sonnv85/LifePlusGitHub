//
//  MerchantTVC.swift
//  LifePlus
//
//  Created by Javu on 6/26/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import SDWebImage

class MerchantTVC: UITableViewCell {

    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantAddressLabel: UILabel!
    @IBOutlet weak var totalCampaignLabel: UILabel!
    @IBOutlet weak var merchantLogoButton: UIButton!
    @IBOutlet weak var registerCustomButton: UIButton!

    var merchant: Merchant! {
        didSet{
            self.merchantNameLabel.text         = merchant.MerchantName
            self.merchantAddressLabel.text      = merchant.Address
            self.totalCampaignLabel.text        = "\(merchant.TotalCampaign!)"
            self.merchantLogoButton.sd_setImage(with: URL(string: merchant.MerchantLogo!), for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.merchantLogoButton.circleButton()
        self.totalCampaignLabel.circleLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func merchantLogoButtonTapped(_ sender: Any) {
    }
    
    @IBAction func registerCustomButtonTapped(_ sender: Any) {
    }
    
}
