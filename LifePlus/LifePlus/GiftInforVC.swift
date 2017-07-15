//
//  GiftInforVC.swift
//  LifePlus
//
//  Created by Javu on 7/10/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class GiftInforVC: BaseTableVC  {

    @IBOutlet weak var memberTypeLabel:     UILabel!
    @IBOutlet weak var merchantNameLabel:   UILabel!
    @IBOutlet weak var logoButton:          UIButton!
    @IBOutlet weak var myPointLabel:        UILabel!


    var merchant:   Merchant? //Is Passed form ExchangePointVC.
    var card:       Card?
    var gifts:      [Campaign]?
    var nextUrl:    String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(title: "THÔNG TIN QUÀ TẶNG")
        self.addPullToRefresh()
        self.addLoadMore()
    }


    func setupHeaderGUI() {
        self.memberTypeLabel.text   = "THÀNH VIÊN \(self.card?.MemberType?.Name?.uppercased() ?? "") CỦA"
        self.merchantNameLabel.text = self.card?.Merchant?.MerchantName?.uppercased()
        self.logoButton.sd_setImage(with: URL(string:(self.card?.Merchant?.MerchantLogo)!), for: .normal, placeholderImage: UIImage(named: "defaultImage"))
        self.logoButton.circleButton()
        self.myPointLabel.text      = "\(card?.PointCard ?? 0)"
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.triggerPullToRefresh()
    }


    override func reloadData(reload: Bool) {
        if reload {
            self.getCard(id: (self.merchant?.Id)!)
            self.getGifts(campaignType: "gift", merchantId: self.merchant?.Id ?? 0)     //<=> get campaigns.
        }
        else {
            self.getGifts(campaignType: "gift", merchantId: self.merchant?.Id ?? 0, reload: false)
        }
    }
    

    func getCard(id: Int) {
        APIManager.getCard(merchantId: id) { (status, card, error) in
            if error == nil {
                self.card = card
                self.endRefresh()
                self.tableView.reloadData()
                self.setupHeaderGUI()
            }
            else {
                self.showMessage(message: error ?? "")
            }
            self.endRefresh()
        }
    }


    func getGifts(campaignType: String, merchantId: Int ,reload: Bool = true) {
        if reload{
            APIManager.getGifts(campaignType: campaignType, merchantId: merchantId, completion: { (status, gifts, nextUrl, error) in
                if error == nil {
                    if let gifts = gifts {
                        self.gifts = gifts
                        self.nextUrl = nextUrl ?? nil
                    }
                    else {
                        print("gifts error!!!")
                    }
                }
                else {
                    self.showMessage(message: error ?? "getGifts error!!!")
                }
                self.endRefresh()
                self.tableView.reloadData()
            })
        }
        else {
            //Load more.
            if self.nextUrl != nil {
                APIManager.getMoreGifts(nextURL: self.nextUrl!, completion: { (success, gifts, nextUrl, error) in
                    if error == nil {
                        if let gifts = gifts {
                            self.gifts?.append(contentsOf: gifts)
                            self.nextUrl = nextUrl
                        }
                        else {
                            print("gifts error!!!")
                        }
                    }
                    else {
                        self.showMessage(message: error ?? "getMoreGifts error!!!")
                    }
                    self.endRefresh()
                })
            }
            else {
                print("self.nextUrl = nil!!!")
                self.endRefresh()
            }
        }
    }
    
    
    //MARK: Table View Data Source.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let gifts = self.gifts?.count {
            return gifts
        }
        else {
            return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftInforTVC") as! GiftInforTVC
        cell.gift = self.gifts![indexPath.row]
        return cell
    }

    
    //MARK: Table View Deleage.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let giftDetailVC        = self.storyboard?.instantiateViewController(withIdentifier: "GiftDetailVC") as! GiftDetailVC
        giftDetailVC.gift       = self.gifts?[indexPath.row]
        giftDetailVC.card       = self.card
        giftDetailVC.merchant   = self.merchant
        _ = self.navigationController?.pushViewController(giftDetailVC, animated: true)
    }

    
}
