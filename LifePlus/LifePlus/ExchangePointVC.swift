//
//  GiftVC.swift
//  LifePlus
//
//  Created by Javu on 7/6/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class ExchangePointVC: BaseTableVC {

    var merchants: [Merchant]?
    var nextUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate     = self
        self.tableView.dataSource   = self
        self.showTitle(title: "ĐỒI ĐIỂM LẤY QUÀ")
        let nib = UINib(nibName: "ExchangePointTVC", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ExchangePointTVC")
        self.addPullToRefresh()
        self.addLoadMore()
    }


    override func reloadData(reload: Bool) {
        if reload {
            self.getMerchantsCustomer(isCustomer: true)
        }
        else {
            self.getMerchantsCustomer(isCustomer: true, reload: false)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMerchantsCustomer(isCustomer: true)
        self.triggerPullToRefresh()
    }


    func getMerchantsCustomer(isCustomer: Bool, reload: Bool = true) {
        if reload {
            APIManager.getMerchantsCustomer(isCustomer: true, completion: { (success, merchants, nextUrl, error) in
                if error == nil {
                    self.merchants = merchants
                    self.nextUrl = nextUrl
                }
                else {
                    self.showMessage(message: error ?? "WTH???")
                }
                self.endRefresh()
            })
        }
        else {
            //Load more.
            if self.nextUrl != nil {
                APIManager.getMoreMerchants(nextURL: self.nextUrl!, completion: { (success, merchants, nextUrl, error) in
                    if error == nil {
                        if let merch = merchants {
                            self.merchants?.append(contentsOf: merch)
                            self.nextUrl = nextUrl
                        }
                        else {
                            print("[merchants] error!!!")
                        }
                    }
                    else {
                        self.showMessage(message: error ?? "WTH???")
                    }
                    self.endRefresh()
                })
            }
            else {
                print("No more nextURL???")
                self.endRefresh()
            }
        }
    }


    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = self.merchants?.count{
            return num
        }
        else {
            return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangePointTVC") as! ExchangePointTVC
        cell.selectionStyle = .none
        cell.merchant = self.merchants?[indexPath.row]
        return cell
    }


    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let giftInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "GiftInforVC") as! GiftInforVC
        giftInfoVC.merchant = self.merchants?[indexPath.row]
        _ = self.navigationController?.pushViewController(giftInfoVC, animated: true)
    }
}
