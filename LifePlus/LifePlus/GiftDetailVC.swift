//
//  GiftDetailVC.swift
//  LifePlus
//
//  Created by Javu on 7/11/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class GiftDetailVC: BaseTableVC {

    @IBOutlet weak var memberTypeLabel:         UILabel!
    @IBOutlet weak var merchantNameLabel:       UILabel!
    @IBOutlet weak var merchantLogoButton:      UIButton!
    @IBOutlet weak var myPointLabel:            UILabel!
    @IBOutlet weak var giftImageVIew:           UIImageView!
    @IBOutlet weak var totalPointCampaignLabel: UILabel!
    @IBOutlet weak var getTimeLabel: UILabel!

    var gift:       Campaign?   //Pass from GiftInforVC
    var card:       Card?       //Pass from GiftInforVC
    var merchant:   Merchant?   //Pass from GiftInforVC
    var giftDetail: Campaign?   // <=> Campaign Detail.

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(title: "THÔNG TIN CHI TIẾT")
        self.addPullToRefresh()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func endRefresh(reloadData: Bool) {
        self.tableView.mj_header.endRefreshing()
        self.tableView.reloadData()
    }


    override func reloadData(reload: Bool) {
        self.getCard(id: (self.merchant?.Id)!)
//        self.getGiftDetail(campaignId: (self.gift?.Id)!)
    }


    func getCard(id: Int) {
        APIManager.getCard(merchantId: id) { (status, card, error) in
            if error == nil {
                self.card = card
                self.endRefresh(reloadData: true)
                self.getGiftDetail(campaignId: (self.gift?.Id)!)
            }
            else {
                self.showMessage(message: error ?? "")
            }
            self.endRefresh(reloadData: true)
        }
    }


    func setupUI() {
        self.memberTypeLabel.text   = "THÀNH VIÊN \(self.card?.MemberType?.Name?.uppercased() ?? "") CỦA"
        self.merchantLogoButton.sd_setImage(with: URL(string: (self.card?.Merchant?.MerchantLogo)!), for: .normal, placeholderImage: UIImage(named: "defaultImage"))
        self.merchantLogoButton.circleButton()
        self.merchantNameLabel.text = self.card?.Merchant?.MerchantName ?? ""
        self.myPointLabel.text      = "\(self.card?.PointCard ?? 0)"
        self.giftImageVIew.sd_setImage(with: URL(string: (self.gift?.Banner)!), placeholderImage: UIImage(named: "defaultImage"))
        self.totalPointCampaignLabel.text = "-\(self.giftDetail?.TotalPointCampaign ?? 0)"
        self.totalPointCampaignLabel.circleLabel()
        self.setupUIForGetTimeLabel()
    }


    func setupUIForGetTimeLabel() {
        let calendar = Calendar.current
        if let startD   = self.giftDetail?.StartDate,
            let endD    = self.giftDetail?.EndDate {
            let startDate   = calendar.dateComponents([.day, .month, .year], from: startD)
            let endDate     = calendar.dateComponents([.day, .month, .year], from: endD)
            self.getTimeLabel.text = "\(startDate.day ?? 01)/\(startDate.month ?? 01)/\(startDate.year ?? 01) - \(endDate.day ?? 01)/\(endDate.month ?? 01)/\(endDate.year ?? 01)"
        }
    }


    func getGiftDetail(campaignId: Int) {
        APIManager.getCampaign(campaignId: campaignId) { (success, gift, error) in
            if error == nil {
                self.giftDetail = gift
                self.tableView.reloadData()
                self.setupUI()
            }
            else {
                self.showMessage(message: error ?? "getGiftDetail error???")
            }
        }
    }


    //MARK: UITable View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let number = self.giftDetail?.Branch?.count {
            if section == 0 {
                if number >= 3 {
                    return 3
                }
                else {
                    return number
                }
            }
            else {
                if number > 3 {
                    return 1
                }
                else {
                    return 0
                }
            }
        }
        else {
            return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell            = tableView.dequeueReusableCell(withIdentifier: "locationsCell")
            let addressLabel    = cell?.viewWithTag(1) as! UILabel
            addressLabel.text   = self.giftDetail?.Branch?[indexPath.row].Address
            return cell!
        default:
            let cell            = tableView.dequeueReusableCell(withIdentifier: "moreLocationsCell")
            let showMoreLocationsButton = cell?.viewWithTag(2) as! UIButton
            showMoreLocationsButton.showsTouchWhenHighlighted = true
            showMoreLocationsButton.layer.cornerRadius = showMoreLocationsButton.bounds.size.height / 2.0
            showMoreLocationsButton.clipsToBounds = true
            showMoreLocationsButton.layer.borderWidth = 1.0
            showMoreLocationsButton.layer.borderColor = UIColor.green.cgColor
            showMoreLocationsButton.addTarget(self, action: #selector(showMoreLocationsButtonTapped), for: .touchUpInside)
            return cell!
        }
    }

    func showMoreLocationsButtonTapped() {
        let locationsVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationsVC") as!LocationsVC
        locationsVC.campaign = self.gift
        _ = self.navigationController?.pushViewController(locationsVC, animated: true)
    }


    //MARK: UITable View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationsVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationsVC") as!LocationsVC
        locationsVC.branchSelected = (self.giftDetail?.Branch?[indexPath.row])
        _ = self.navigationController?.pushViewController(locationsVC, animated: true)
    }

    @IBAction func getGiftCodeButtonTapped(_ sender: Any) {

    }
}
