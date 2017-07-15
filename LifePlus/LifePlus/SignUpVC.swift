//  SignUpVC.swift
//  LifePlus
//
//  Created by Javu on 6/7/17.
//  Copyright © 2017 Javu. All rights reserved.

import UIKit
import MIAlertController

class SignUpVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    var merchantSelected: Merchant?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ĐĂNG KÝ"
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func registerButtonTapped(_ sender: Any) {
        self.checkData()
    }


    func checkData() {
        let email       = self.emailTextField.text
        let password    = self.passwordTextField.text
        let phone       = self.phoneTextField.text
        let name        = self.nameTextField.text
        let merchantId  = String(self.merchantSelected!.Id!)

        if checkEmail(email: email!) == false{
            self.showMessage(message: "Email không hợp lệ")
            return
        }

        if checkPassword(password: password!) == false {
            self.showMessage(message: "Mật khẩu không hợp lệ")
            return
        }

        if checkPhone(phone: phone!) == false {
            self.showMessage(message: "Số điện thoại không hợp lệ")
            return
        }


        APIManager.signUp(email: email!,
                          password: password!,
                          phone: phone!,
                          name: name! ,
                          merchantId: merchantId) { (success, user, error) in
                            if error == nil {
                                print(user ?? "WTF!!!")
                                let confirmActiveAcountVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmActiveAccountVC") as! ConfirmActiveAccountVC
                                confirmActiveAcountVC.user = user
                                _ = self.navigationController?.pushViewController(confirmActiveAcountVC, animated: true)
                            }
                            else {
                                print(error ?? "WTF???")
                            }
        }
    }


    func checkEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }


    func checkPassword(password: String) -> Bool {
        if password.characters.count >= 6 {
            return true
        }
        else {
            return false
        }
    }


    func checkPhone(phone: String) -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: phone, options: [], range: NSMakeRange(0, phone.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == phone.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    
    @IBAction func signInNowButtonTapped(_ sender: Any) {
    }
}
