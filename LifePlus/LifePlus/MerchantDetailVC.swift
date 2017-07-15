//
//  MerchantDetailVC.swift
//  LifePlus
//
//  Created by Javu on 6/28/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class MerchantDetailVC: BaseTableVC {

    @IBOutlet weak var merchantLogoButton:  UIButton!
    @IBOutlet weak var merchantNameLabel:   UILabel!
    @IBOutlet weak var inforView:           UIView!
    @IBOutlet weak var openTimeLabel:       UILabel!
    @IBOutlet weak var closeTimeLabel:      UILabel!
    @IBOutlet weak var hotlineLabel:        UILabel!
    @IBOutlet weak var websiteButton:       UIButton!

    @IBOutlet var descriptionsView:     UIView!
    @IBOutlet var infoView:             UIView!
    @IBOutlet weak var viewForScroll:   UIView!

    var scrollViewInfo: UIScrollView!

    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!

    @IBOutlet weak var merchantDescriptionLabel: UILabel!
    @IBOutlet weak var totalCampaignCouponLabel: UILabel!
    @IBOutlet weak var totalCampaignGiftLabel: UILabel!
    @IBOutlet weak var totalCustomLabel: UILabel!
    
    var merchantIdSelected: Int?
    var merchant: Merchant?
    var coupons = [Campaign]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate     = self
        self.tableView.dataSource   = self
        self.getMerchantDetail()
    }


    func getMerchantDetail() {
        if let id = self.merchantIdSelected {
            APIManager.getAMerchant(merchantId: id) { (success, merchant, error) in
                if error == nil {
                    self.merchant = merchant
                    self.getCouponSponsoring(merchantId: id)
                    self.tableView.reloadData()
                    self.setupUI()
                }
                else {
                    self.showMessage(message: error ?? "WTH???")
                }
            }
        }
    }


    func getCouponSponsoring(merchantId: Int) {
        APIManager.getCouponSponsoring(merchantId: merchantId) { (success, coupons, nextURL, error) in
            if error == nil {
                if let coupons = coupons {
                    self.coupons = coupons
                    self.tableView.reloadData()
                }
            }
            else {
                self.showMessage(message: error ?? "WTH ???")
            }
        }
    }


    func setupUI() {
        self.merchantLogoButton.sd_setImage(with: URL(string: self.merchant?.MerchantLogo ?? ""), for: .normal)
        self.merchantLogoButton.circleButton()
        self.merchantNameLabel.text     = self.merchant?.MerchantName ?? ""
        //self.setupTimeOpenAndClose()
        self.openTimeLabel.text         = self.merchant?.Open ?? ""
        self.closeTimeLabel.text        = self.merchant?.Close ?? ""
        self.hotlineLabel.text          = self.merchant?.Phone ?? ""
        self.setupUIForWebsite()
        self.ShowDescriptions()
        self.merchantDescriptionLabel.text  = self.merchant?.MerchantDescription ?? ""
        self.totalCampaignCouponLabel.text  = "\(self.merchant?.TotalCampaignCoupon ?? 0)"
        self.totalCampaignGiftLabel.text    = "\(self.merchant?.TotalCampaignGift ?? 0)"
        self.totalCustomLabel.text          = "\(self.merchant?.TotalCustomer ?? 0)"
    }


    func setupUIForWebsite() {
        let link = self.merchant?.Website ?? ""
        let linkAttributes = NSMutableAttributedString(string: link, attributes: [
            NSUnderlineStyleAttributeName: NSNumber(integerLiteral: 1),
            ])
        self.websiteButton.setAttributedTitle(linkAttributes, for: .normal)
    }


//    func setupTimeOpenAndClose() {
//        let calendar = Calendar.current
//        if let openHour = self.merchantSelected?.Open, let closeHour = self.merchantSelected?.Close {
//            let openDateComponents = calendar.dateComponents([.hour, .minute], from: openHour)
//            let closeDateComponents = calendar.dateComponents([.hour, .minute], from: closeHour)
//            let openH = openDateComponents.hour
//            let openM = openDateComponents.minute
//            let closeH = closeDateComponents.hour
//            let closeM = closeDateComponents.minute
//
//            self.openTimeLabel.text = "\(openH ?? 0):\(openM ?? 0)"
//            self.closeTimeLabel.text = "\(closeH ?? 0):\(closeM ?? 0)"
//        }
//    }



    func ShowDescriptions (){
        self.scrollViewInfo = UIScrollView(frame: CGRect(origin: CGPoint(x: 15, y: 0), size: CGSize(width: self.view.frame.size.width - 30, height: self.viewForScroll.frame.size.height)))

        self.descriptionsView.frame = CGRect(x: 0, y: 0, width: (self.scrollViewInfo.frame.size.width), height: (self.scrollViewInfo.frame.size.height))

        self.inforView.frame = CGRect(x: self.scrollViewInfo.frame.size.width, y: 0, width: (self.scrollViewInfo.frame.size.width), height: (self.scrollViewInfo.frame.size.height))

        self.scrollViewInfo.addSubview(self.descriptionsView)
        self.scrollViewInfo.addSubview(self.inforView)

        self.scrollViewInfo.contentSize = CGSize(width: self.scrollViewInfo.frame.size.width * 2, height: self.self.scrollViewInfo.frame.size.height)


        self.scrollViewInfo.isPagingEnabled = true
        self.scrollViewInfo.showsVerticalScrollIndicator = false
        self.scrollViewInfo.showsHorizontalScrollIndicator = false
        self.viewForScroll.addSubview(self.scrollViewInfo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func leftScrollButtonTapped(_ sender: Any) {
    }


    @IBAction func rightScrollButtonTapped(_ sender: Any) {
    }


    @IBAction func websiteButtonTapped(_ sender: Any) {
        let link = self.merchant?.Website
        if self.verifyUrl(urlString: link) {
            UIApplication.shared.openURL(URL(string: link ?? "")!)
        }
        else {
            self.showMessage(message: "Link is invalid!!!")
        }
    }

    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString){
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }



    //MARK: #UITableView Data Source.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            //Locations.
            if let locations = self.merchant?.Branch?.count {
                if locations >= 3 {
                    return 3
                }
                return locations
            }
        case 1:
            //Button more locations.
            if self.merchant?.Branch?.count ?? 1 > 3 {
                return 1
            }
            else {
                return 0
            }
        case 2:
            //Close customer register.
            return 1
        case 3:
            //Provider pictures (collection view).
            return 1

        case 4:
            // couponSponsoringCell (static)
            if self.coupons.count == 0 {
                return 0
            }
            else {
                return 1
            }
        case 5:
            return self.coupons.count
        default:
            return 1
        }
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: //Locations.
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")
            let locationLabel = cell?.viewWithTag(1) as! UILabel
            locationLabel.text = self.merchant?.Branch?[indexPath.row].Address
            
            return cell!

        case 1://Button more locations.
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreLocationCell")
            let moreLocationButton                          = cell?.viewWithTag(2) as! UIButton
            moreLocationButton.layer.borderColor            = UIColor.green.withAlphaComponent(0.5).cgColor
            moreLocationButton.layer.borderWidth            = 1.0
            moreLocationButton.layer.cornerRadius           = moreLocationButton.bounds.size.height / 2.0
            moreLocationButton.showsTouchWhenHighlighted    = true
            moreLocationButton.addTarget(self, action: #selector(moreLocationButtonTapped), for: .touchUpInside)

            return cell!

        case 2://Close customer register.
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell")
            let registerCloseCustomerButton = cell?.viewWithTag(3) as! UIButton
            registerCloseCustomerButton.layer.cornerRadius = registerCloseCustomerButton.bounds.size.width / 2.0
            registerCloseCustomerButton.clipsToBounds = true
            registerCloseCustomerButton.showsTouchWhenHighlighted = true
            registerCloseCustomerButton.addTarget(self, action: #selector(registerCloseCustomerButtonTapped), for: .touchUpInside)
            cell?.selectionStyle = .none
            return cell!

        case 3://Provider pictures (collection view).
            let cell = tableView.dequeueReusableCell(withIdentifier: "providerPicturesCell") as! ProviderTVC
            cell.selectionStyle = .none
            if let item = self.merchant {
                cell.merchant = item
            }
            return cell
        case 4:
            // couponSponsoringCell (static)
            let cell = tableView.dequeueReusableCell(withIdentifier: "couponSponsorCell")
            return cell!

        default:
            //couponSponsoringCell. Last cell. ^^!
            let cell    = tableView.dequeueReusableCell(withIdentifier: "couponSponsoringCell") as! CouponSponsoringTVC
            cell.coupon = self.coupons[indexPath.row]
            cell.merchantName = self.merchant?.MerchantName
            return cell
        }
    }


    func registerCloseCustomerButtonTapped() {
        print("registerCloseCustomerButtonTapped!!! ")
    }


    func moreLocationButtonTapped () {
        print("moreLocationButtonTapped!!!")
    }


    //MARK: #UITableView Delegate.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0://Locations.
            return 40
        case 1://Button more locations.
            return 40
        case 2://Close customer register.
            return 40
        case 3://Provider pictures (collection view).
            return 120
        case 4: // couponSponsoringCell (static)
            return 40
        default://couponSponsoringCell. Last cell. ^^!
            return 215
        }
    }
}
