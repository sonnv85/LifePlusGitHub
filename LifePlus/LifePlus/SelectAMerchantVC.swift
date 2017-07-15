
//
//  RegisterVC.swift
//  LifePlus
//
//  Created by Javu on 6/6/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class SelectAMerchantVC: BaseTableVC {

    var merchants = [Merchant]()
    var nextURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate     = self
        self.tableView.dataSource   = self
        let nib = UINib(nibName: "SelectAMerchantTVC", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "SelectAMerchantTVC")
        self.showTitle(title: "KHÁCH HÀNG THÂN THIẾT", color: .lightText)
        self.addPullToRefresh()
        self.addLoadMore()
//        self.showNavigationBar(isWhite: false)
        self.showBackButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func reloadData(reload: Bool) {
        if reload {
            self.getMerchants(name: "", size: 10)
        }
        else {
            self.getMerchants(name: "", size: 10, reload: false)
        }
    }

    func getMerchants(name: String, size: Int, reload: Bool = true) {
        if reload {
            APIManager.getMerchants(name: name, size: size, completion: { (success, merchants, nextURL, error) in
                if error == nil {
                    if let merchants = merchants {
                        self.merchants = merchants
                        self.nextURL = nextURL
                    }
                    else {
                        print("merchants nil!!!")
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
                            print("merchants = nil???")
                        }
                    }
                    else {
                        self.showMessage(message: error ?? "WTH???")
                    }
                    self.endRefresh()
                })
            }
            else {
                print("self.nextURL = nil!!!")
                self.endRefresh()
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: UITableView Data Source.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.merchants.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAMerchantTVC") as! SelectAMerchantTVC
        cell.selectionStyle = .none
        let aMerchant = self.merchants[indexPath.row]
        cell.aMerchant = aMerchant
        return cell
    }

    //MARK: UITableView Delegate.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        signUpVC.merchantSelected = self.merchants[indexPath.row]
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
}
