//
//  GetCouponVCViewController.swift
//  LifePlus
//
//  Created by Javu on 6/22/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import SDWebImage

class GetCouponVC: UIViewController {

    @IBOutlet weak var tableView:           UITableView!
    @IBOutlet weak var couponImageView:     UIImageView!
    @IBOutlet weak var daysLabel:           UILabel!
    @IBOutlet weak var timeLabel:           UILabel!
    @IBOutlet weak var merchantNameLabel:   UILabel!
    @IBOutlet weak var fromTimeLabel:       UILabel!
    @IBOutlet weak var toTimeLabel:         UILabel!
    @IBOutlet weak var merchantLogoButton:  UIButton!
    @IBOutlet weak var getCouponButton:     UIButton!

    var campaignIdSelected: Int?        //From home
    var campaign:           Campaign?   //self.getCaimpaign() //Campaign Detail.
    var timer:              Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(title: "NHẬN COUPON")
        self.showBackButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCampaign()
    }

    func setupUI() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupHeaderUI() {
        if let imageURL             = self.campaign?.Banner {
            self.couponImageView.sd_setImage(with: URL(string: imageURL))
        }
        self.timer                  = Timer.scheduledTimer(timeInterval: 1.0,
                                                           target: self,
                                                           selector: #selector(CountDowntime),
                                                           userInfo: nil,
                                                           repeats: true)
        self.merchantNameLabel.text = self.campaign?.Merchant?.MerchantName!
//        self.OpenAndCloseTime()
        self.fromTimeLabel.text = self.campaign?.Merchant?.Open ?? ""
        self.toTimeLabel.text   = self.campaign?.Merchant?.Close ?? ""
        if let logoLink         = URL(string: (self.campaign?.Merchant?.MerchantLogo)!){
            self.merchantLogoButton.sd_setImage(with: logoLink, for: .normal)
        }
        self.merchantLogoButton.circleButton()
        self.merchantLogoButton.showsTouchWhenHighlighted = true
    }

//    func OpenAndCloseTime() {
//        let calendar = Calendar.current
//        if let openHour = self.coupon?.Merchant?.Open,
//            let closeHour = self.coupon?.Merchant?.Close {
//            let openDateComponents  = calendar.dateComponents([.hour, .minute], from: openHour)
//            let closeDateComponents = calendar.dateComponents([.hour, .minute], from: closeHour)
//            let openHour    = openDateComponents.hour
//            let closeHour   = closeDateComponents.hour
//            if let openHour = openHour,
//                let closeHour = closeHour{
//                if openHour < 12 {
//                    self.fromTimeLabel.text = "\(openHour) AM"
//                }
//                else {
//                    self.fromTimeLabel.text = "\(openHour) PM"
//                }
//
//                if closeHour < 12 {
//                    self.toTimeLabel.text = "\(closeHour) AM"
//                }
//                else {
//                    self.toTimeLabel.text = "\(closeHour) PM"
//                }
//            }
//        }
//    }


    func CountDowntime() {
        let calendar    = Calendar.current
        if let endDate  = self.campaign?.EndDate {
            let dateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: Date(), to: endDate)
            if dateComponents.day! < 10 {
                self.daysLabel.text = "0\(dateComponents.day!)"
            }
            else {
                self.daysLabel.text = "\(dateComponents.day!)"
            }

            var timeString  = ""
            if dateComponents.hour! < 10 {
                let hour    = "0\(dateComponents.hour!):"
                timeString.append(hour)
            }
            else {
                let hour    = "\(dateComponents.hour!):"
                timeString.append(hour)
            }

            if dateComponents.minute! < 10 {
                let minuter = "0\(dateComponents.minute!):"
                timeString.append(minuter)
            }
            else {
                let minuter = "\(dateComponents.minute!):"
                timeString.append(minuter)
            }

            if dateComponents.second! < 10 {
                let second  = "0\(dateComponents.second!)"
                timeString.append(second)
            }
            else {
                let second  = "\(dateComponents.second!)"
                timeString.append(second)
            }
            self.timeLabel.text = timeString
        }
    }

    func getCampaign() {
        if  let id = self.campaignIdSelected {
            APIManager.getCampaign(campaignId: id) { (success, campaign, error) in
                if error == nil {
                    self.campaign = campaign
                    self.tableView.reloadData()
                    self.setupHeaderUI()
                }
                else {
                    self.showMessage(message: error ?? "WTH???")
                }
            }
        }
        else {
            print("self.campaignIdSelected = nil")
        }
    }


    @IBAction func getCouponButtonTapped(_ sender: Any) {
        self.receiveCouponAuto()
    }


    func receiveCouponAuto() {
        APIManager.receiveCouponAuto(campaignId: (self.campaign?.Id)!, branchId: (self.campaign?.Branch?.first?.Id)!, completion: { (status, message, coupon, error) in
            if error == nil {
                let qrReaderVC = self.storyboard?.instantiateViewController(withIdentifier: "QRReaderVC") as! QRReaderVC
                qrReaderVC.coupon = coupon
                self.navigationController?.pushViewController(qrReaderVC, animated: true)
            }
            else {
                self.showMessage(message: error ?? "WTH???")
            }
        })
    }
}


extension GetCouponVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  section == 0 {
            if let row = self.campaign?.Branch {
                if row.count > 3{
                    return 3
                }
                else {
                    return row.count
                }
            }
            return 0
        }
        if section == 1 {
            if let row = self.campaign?.Branch {
                if row.count > 3{
                    return 1
                }
                else {
                    return 0
                }
            }
        }
        return 1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "locationCell")
            let locationLabel   = cell?.viewWithTag(1) as! UILabel
            locationLabel.text  = self.campaign?.Branch?[indexPath.row].Address!

            return cell!
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "moreLocationCell")
            let moreLocationButton = cell?.viewWithTag(2) as! UIButton
            moreLocationButton.layer.borderColor = UIColor.green.withAlphaComponent(0.5).cgColor
            moreLocationButton.layer.borderWidth = 1.0
            moreLocationButton.layer.cornerRadius = moreLocationButton.bounds.size.height / 2.0
            moreLocationButton.showsTouchWhenHighlighted = true
            moreLocationButton.addTarget(self, action: #selector(moreLocationButtonTapped), for: .touchUpInside)

            return cell!
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "registerCell")
            let registerCloseCustomerButton = cell?.viewWithTag(3) as! UIButton
            registerCloseCustomerButton.layer.cornerRadius = registerCloseCustomerButton.bounds.size.width / 2.0
            registerCloseCustomerButton.clipsToBounds = true
            registerCloseCustomerButton.showsTouchWhenHighlighted = true
            registerCloseCustomerButton.addTarget(self, action: #selector(registerCloseCustomerButtonTapped), for: .touchUpInside)

            return cell!
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "descriptionCell")
            cell?.separatorInset = UIEdgeInsetsMake(0, (cell?.bounds.size.width)!, 0, 0)
            let descriptionLabel = cell?.viewWithTag(4) as! UILabel
            descriptionLabel.text = self.campaign?.Description!
            let scrollToTopButton = cell?.viewWithTag(5) as! UIButton
            scrollToTopButton.layer.cornerRadius = scrollToTopButton.bounds.size.width / 2.0
            scrollToTopButton.clipsToBounds = true
            scrollToTopButton.showsTouchWhenHighlighted = true
            scrollToTopButton.addTarget(self, action: #selector(scrollToTopButtonTapped), for: .touchUpInside)

            return cell!
        }
    }

    func scrollToTopButtonTapped() {
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
    }

    func registerCloseCustomerButtonTapped() {
        print("registerCloseCustomerButtonTapped???")
    }

    func moreLocationButtonTapped() {
        print("moreLocationButtonTapped???")
    }
}

extension GetCouponVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 3:
            return 200
        default:
            return 50
        }
    }
}
