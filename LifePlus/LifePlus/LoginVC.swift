//
//  LoginVC.swift
//  LifePlus
//
//  Created by Javu on 6/5/17.
//  Copyright © 2017 Javu. All rights reserved.
// App ID: 999765530158987 (mudaheo@gmail.com)
// App ID: 1396207410440383 (life plus)

import UIKit
import FBSDKLoginKit

class LoginVC: UIViewController {

    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerNowButton: UIButton!
    @IBOutlet weak var loginWithFacebookButton: UIButton!
    var user: ((User) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default

        if let accessToken = FBSDKAccessToken.current() {
            //Đã login facebook
            print(accessToken)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showTitle(title: "ĐĂNG NHẬP", color: .white)
        self.showDismissButton()
        self.navigationController?.showNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancelBarButtonTapped(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        let forgotPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        _ = self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        if let username = self.emailTextField.text?.trimmed(),
            username.checkEmpty() == false,
            let password = self.passwordTextField.text?.trimmed(),
            password.checkEmpty() == false {
            APIManager.login(username: username, password: password) { (success, user, error) in
                if error == nil {
                    if let user = user {
                        user.save()
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.showMessage(message: error!)
                }
            }
        } else {
            print("Check Username or Password again!!!")
        }
    }


    @IBAction func registerNowButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SelectAMerchantVC") as! SelectAMerchantVC
        _ = self.navigationController?.pushViewController(controller, animated: true)
    }


    @IBAction func registerWithFacebookButtonTapped(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                print(error ?? "WTHloginManager.logIn error!!!")
            }
            else if (result?.isCancelled)! {
                loginManager.logOut()
                print("Done / Cancel Tapped!!!")
            }
            else {
                APIManager.loginWithFacebook(facebookToken: (result?.token.tokenString)!, completion: { (sucess, user, error) in
                    if error == nil {
                        self.user?(user!)
                        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
                        let selectAMerchantVC = storyboard.instantiateViewController(withIdentifier: "SelectAMerchantVC") as! SelectAMerchantVC
                        _ = self.navigationController?.pushViewController(selectAMerchantVC, animated: true)
                    }
                    else {
                        self.showMessage(message: error!)
                    }
                })
            }
        }
    }
}
