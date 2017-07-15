//
//  SearchTVC.swift
//  LifePlus
//
//  Created by Javu on 6/12/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class SearchTVC: UITableViewCell {

    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var rewardAmountLabel: UILabel!
    @IBOutlet weak var totalPointCampaignButton: UIButton!
    @IBOutlet weak var campaignBannerButton: UIButton!

    var camPaign: Campaign! {
        didSet{
            self.campaignNameLabel.text = camPaign.Name
            self.viewsLabel.text        = String(camPaign.View!)
            self.rewardAmountLabel.text = String(camPaign.RewardAmount!)
            self.totalPointCampaignButton.setTitle("\(camPaign.TotalPointCampaign!)", for: .normal)
            self.totalPointCampaignButton.layer.cornerRadius = self.totalPointCampaignButton.bounds.size.width / 2
            self.clipsToBounds = true
            self.campaignBannerButton.sd_setBackgroundImage(with: URL(string: camPaign.Banner!), for: .normal)
            self.campaignBannerButton.circleButton()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
