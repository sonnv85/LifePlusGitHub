//
//  GiftInforTVC.swift
//  LifePlus
//
//  Created by Javu on 7/10/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class GiftInforTVC: UITableViewCell {

    @IBOutlet weak var campaignBannerImageView: UIImageView!
    @IBOutlet weak var totalPointCampaignLabel: UILabel!
    @IBOutlet weak var endDateLabel:            UILabel!


    var gift: Campaign! {
        didSet{
            self.campaignBannerImageView.sd_setImage(with: URL(string: gift.Banner!), placeholderImage: UIImage(named: "defaultImage"))
            self.totalPointCampaignLabel.circleLabel()
            self.totalPointCampaignLabel.text = "-\(gift.TotalPointCampaign  ?? 00)"
            let calendar            = Calendar.current
            let enDateComponents    = calendar.dateComponents([.day, . month, .year], from: gift.EndDate!)
            let day         = enDateComponents.day
            let month       = enDateComponents.month
            let year        = enDateComponents.year
            self.endDateLabel.text  = "ĐẾN \(day ?? 00)/\(month ?? 00)/\(year ?? 00)"
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
