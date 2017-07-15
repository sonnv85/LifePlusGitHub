//
//  HomeTVC.swift
//  LifePlus
//
//  Created by Javu on 6/8/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTVC: UITableViewCell {

    @IBOutlet weak var campaignImageView: UIImageView!
    @IBOutlet weak var merchantLogoButton: UIButton!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var rewardAmountLabel: UILabel!

    var campaign: Campaign! {
        didSet{
            self.campaignImageView.sd_setImage(with: URL(string: campaign.Banner!))
            self.merchantLogoButton.circleButton()
            self.merchantLogoButton.sd_setImage(with: URL(string: (campaign.Merchant?.MerchantLogo)!), for: .normal)
            self.campaignNameLabel.text = campaign.Name!
            self.merchantNameLabel.text = campaign.Merchant?.MerchantName!.uppercased()
            self.viewsLabel.text        = String(campaign.View!)
            self.rewardAmountLabel.text = String(campaign.RewardAmount!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func merchantLogoButtonTapped(_ sender: Any) {
        print("Logo button tapped!!!")
    }
}

