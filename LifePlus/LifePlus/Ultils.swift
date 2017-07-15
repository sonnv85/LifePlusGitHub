//
//  Ultils.swift
//  LifePlus
//
//  Created by Javu on 6/5/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import MIAlertController

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }

    func checkEmpty() -> Bool{
        return self.trimmed().isEmpty
    }
}

extension UIButton {
    func circleButton() {
        self.showsTouchWhenHighlighted = true
        self.layer.borderColor  = UIColor.gray.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth  = 2.0
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.clipsToBounds      = true
    }
}

extension UILabel {
    func circleLabel() {
        self.layer.borderColor  = UIColor.gray.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth  = 2.0
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.clipsToBounds      = true
    }
}

extension UIViewController {

    func showMessage(message: String) {
        var config = MIAlertController.Config()
        config.titleLabelTextColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        config.titleLabelFont = UIFont.boldSystemFont(ofSize: 15.0)
        config.messageLabelFont = UIFont.boldSystemFont(ofSize: 15.0)

        var configButton = MIAlertController.Button.Config()
        configButton.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        configButton.buttonHeight = 50.0
        configButton.font = UIFont.boldSystemFont(ofSize: 15.0)
        configButton.backgroundColor = #colorLiteral(red: 0.4122548797, green: 0.7595930385, blue: 0.3220172423, alpha: 1)

        MIAlertController(title: "THÔNG BÁO!", message: message, buttons: [
            MIAlertController.Button(title: "OK", type: .default, config: configButton, action: {
                print("OK Tapped")
            })
            ], config: config).presentOn(self)
    }


    func showTitle(title: String, color: UIColor = UIColor.white) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = color
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }

    func showBackButton() {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
        backButton.showsTouchWhenHighlighted = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        backButton.setImage(UIImage(named: "ic_back"), for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    func backButtonTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }


    func showDismissButton() {
        let dismissButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
        dismissButton.showsTouchWhenHighlighted = true
        dismissButton.setBackgroundImage(UIImage(named: "ic_close_grey")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dismissButton.tintColor = UIColor.white
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
    }

    func dismissButtonTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }




}
//func setupBackgroundRadiant() {
//    let bgImage = UIImage(named: "nav_bg_radient")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
//    self.navigationBar.setBackgroundImage(bgImage, for: .any, barMetrics: .default)
//    self.navigationBar.shadowImage = UIImage()
//}
//
//public func setupBackgroundWhite() {
//    self.navigationBar.isTranslucent = false
//    var navSize = self.navigationBar.bounds.size
//    navSize.height += 30
//    self.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.white, size: navSize), for: .any, barMetrics: .default)
//    self.navigationBar.shadowImage = UIImage()
//}

extension UINavigationController {
    func showNavigationBar(isWhite: Bool = true) {
        if isWhite {
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.isTranslucent = false
            self.navigationBar.shadowImage = UIImage()
        }
        else {
            let img = UIImage(named: "navigationBar")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
            self.navigationBar.setBackgroundImage(img, for: .any, barMetrics: .default)
            self.navigationBar.isTranslucent = false
            self.navigationBar.shadowImage = UIImage()
        }
    }

}

