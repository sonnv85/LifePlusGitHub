//
//  RegisterTVC.swift
//  LifePlus
//
//  Created by Javu on 6/6/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import SDWebImage

class SelectAMerchantTVC: UITableViewCell {

    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantLocationLabel: UILabel!
    @IBOutlet weak var totalCampaignButton: UIButton!
    @IBOutlet weak var logoMerchantButton: UIButton!
    @IBOutlet weak var addButton: UIButton!


    var aMerchant: Merchant! {
        didSet{
            self.merchantNameLabel.text     = aMerchant.MerchantName
            self.merchantLocationLabel.text = aMerchant.Location
            self.totalCampaignButton.setTitle("\(aMerchant.TotalCampaign!)", for: .normal)
            self.logoMerchantButton.sd_setBackgroundImage(with: URL(string: aMerchant.MerchantLogo!), for: .normal)
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        self.totalCampaignButton.layer.cornerRadius = self.totalCampaignButton.bounds.size.width / 2
        self.totalCampaignButton.clipsToBounds = true
        self.logoMerchantButton.circleButton()
        self.logoMerchantButton.backgroundColor = UIColor.white
        self.addButton.layer.cornerRadius = self.addButton.bounds.size.width / 2
        self.addButton.clipsToBounds = true
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    @IBAction func totalCampaignButtonTapped(_ sender: Any) {
        print("totalCampaignButtonTapped!!!")
    }


    @IBAction func logoButtonTapped(_ sender: Any) {
        print("logoButtonTapped!!!")
    }


    @IBAction func addButtonTapped(_ sender: Any) {
        print("addButtonTapped!!!")
    }
}
