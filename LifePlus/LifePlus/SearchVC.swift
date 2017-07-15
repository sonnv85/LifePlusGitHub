//
//  SearchVC.swift
//  LifePlus
//
//  Created by Javu on 6/12/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class SearchVC: BaseTableVC {

    @IBOutlet weak var searchTextField: UITextField!
    var coupons = [Campaign]()
    var nextURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate         = self
        self.tableView.dataSource       = self
        self.searchTextField.delegate   = self
        let nib = UINib(nibName: "SearchTVC", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "SearchTVC")
        self.getCampaigns(groupType: "")

        self.addPullToRefresh()
        self.addLoadMore()
    }

    override func reloadData(reload: Bool) {
        if reload {
            // Pull to refresh
            self.getCampaigns(groupType: "")
        }
        else{
            // Load more
            self.getCampaigns(groupType: "", reload: false)
        }
    }


    func getCampaigns(groupType: String, reload: Bool = true) {
        if reload {
            APIManager.getCampaigns(groupType: groupType, size: 10, completion: { (success, campaigns, nextURL, error) in
                if error == nil {
                    self.coupons = campaigns!
                    self.nextURL = nextURL
                }
                else {
                    self.showMessage(message: error ?? "WTH???")
                }
                self.endRefresh()
            })
        }
        else {
            //Load more.
            if let nextURL = self.nextURL {
                APIManager.getNextCampaigns(nextURL: nextURL, completion: { (success, campaigns, nextURL, error) in
                    if error == nil {
                        self.coupons.append(contentsOf: campaigns!)
                        self.nextURL = nextURL
                    }
                    else {
                        self.showMessage(message: error ?? "WTH???")
                    }
                    self.endRefresh()
                })
            }
            else {
                print("self.nextURL = nil???")
            }
            self.endRefresh()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: #UITableView Data Source:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coupons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVC") as! SearchTVC
        cell.selectionStyle = .none
        let aCampaign = self.coupons[indexPath.row]
        cell.camPaign = aCampaign
        return cell
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchCouponsWithName(name: self.searchTextField.text!)
        return true
    }

    func searchCouponsWithName(name: String, reload: Bool = true) {
        if reload {
            APIManager.searchCoupons(name: name) { (success, coupons, nextURL, error) in
                if error == nil {
                    if let coupons = coupons {
                        self.coupons = coupons
                        self.nextURL = nextURL
                        self.tableView.reloadData()
                    }
                    else {
                        print("coupons not found!!!")
                    }
                }
                else {
                    self.showMessage(message: error ?? "WTH???")
                }
            }
        }
        else {
            //Load more.
            if let url = self.nextURL {
                APIManager.getMoreSearchCoupons(nextURL: url, completion: { (success, coupons, nextURL, error) in
                    if error == nil {
                        if let moreCoupons = coupons {
                            self.coupons.append(contentsOf: moreCoupons)
                            self.nextURL = nextURL
                            self.tableView.reloadData()
                        }
                        else {
                            print("coupons not found !!!")
                        }
                    }
                    else {
                        self.showMessage(message: error ?? "load more search error!!!")
                    }
                })
            }
            else {
                print("nextURL not found!!!")
            }
        }

    }
    
    //MARK: #UITableView Delegate:
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
