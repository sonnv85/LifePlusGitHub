//  ConfirmActiveAccount.swift
//  LifePlus
//
//  Created by Javu on 6/7/17.
//  Copyright © 2017 Javu. All rights reserved.

import UIKit

class ConfirmActiveAccountVC: UIViewController {
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var activeCodeTextField: UITextField!
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }


    func setupUI() {
        if let phoneNumber = self.user?.Phone {
            self.phoneLabel.text = "+84\(phoneNumber)"
        }
        self.title = "XÁC NHẬN"
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func confirmButtonTapped(_ sender: Any) {
        let activeCode = self.activeCodeTextField.text
        APIManager.activeAccount(activeCode: activeCode!) { (success, user, error) in
            if error == nil {
                if let user = user {
                    user.save()
                }
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
            else {
                print(error ?? "WTH???")
            }
        }
    }


    @IBAction func receiveNowButtonTapped(_ sender: Any) {
    }
}
