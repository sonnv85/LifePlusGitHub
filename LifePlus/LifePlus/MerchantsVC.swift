//
//  MerchantsVC.swift
//  LifePlus
//
//  Created by Javu on 6/26/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class MerchantsVC: BaseTableVC {

    var merchants = [Merchant]()
    var nextURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTitle(title: "THƯƠNG HIỆU")
        self.tableView.delegate     = self
        self.tableView.dataSource   = self
        let nib = UINib(nibName: "MerchantTVC", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MerchantTVC")
        self.addPullToRefresh()
        self.addLoadMore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBackButton()

        self.getMerchant()
    }

    override func reloadData(reload: Bool) {
        if reload {
            self.getMerchant()
        }
        else {
            self.getMerchant(reload: false)
        }
    }

    func getMerchant(reload: Bool = true) {
        if reload {
            APIManager.getMerchants(name: "", size: 10, completion: { (success, merchants, nextURL, error) in
                if error == nil {
                    if let merchants = merchants {
                        self.merchants = merchants
                        self.nextURL = nextURL
                    }
                    else {
                        print("merchants nil???")
                    }
                }
                else {
                    self.showMessage(message: error ?? "WTH???")
                }
                self.endRefresh()
            })
        }
        else {
            //Load more.
            if self.nextURL != nil {
                APIManager.getMoreMerchants(nextURL: self.nextURL!, completion: { (success, merchants, nextURL, error) in
                    if error == nil {
                        if let merchants = merchants {
                            self.merchants.append(contentsOf: merchants)
                            self.nextURL = nextURL
                        }
                        else {
                            print("merchants nil???")
                        }
                    }
                    else {
                        self.showMessage(message: error ?? "WTH???")
                    }
                    self.endRefresh()
                })
            }
            else {
                print("self.nextURL nil ???")
            }
            self.endRefresh()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: #Tableview Data Source.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.merchants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "MerchantTVC") as! MerchantTVC
        cell.merchant = self.merchants[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    //MARK: #Tableview Deltegate.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let merchantDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MerchantDetailVC") as! MerchantDetailVC
        merchantDetailVC.merchantIdSelected = self.merchants[indexPath.row].Id
        _ = self.navigationController?.pushViewController(merchantDetailVC, animated: true)
    }

}
