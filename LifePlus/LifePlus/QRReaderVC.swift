//
//  QRReaderVC.swift
//  LifePlus
//
//  Created by Javu on 7/5/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation
import SnapKit

class QRReaderVC: UIViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var qrView: UIView!
    @IBOutlet weak var TitleQRLabel: UILabel!
    @IBOutlet weak var findAnotherCouponButton: UIButton!
    @IBOutlet weak var showCouponWallet: UIButton!

    var coupon: Coupon?

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
            $0.showCancelButton = false
        }
        return QRCodeReaderViewController(builder: builder)
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    func setupUI() {
        self.TitleQRLabel.text = "Quét mã QR để sử dụng Coupon"
        self.view.addSubview(self.readerVC.view)
        self.readerVC.didMove(toParentViewController: self)
        self.addChildViewController(self.readerVC)
        self.view.bringSubview(toFront: qrView)
        self.readerVC.delegate = self
        self.qrView.backgroundColor = UIColor.clear
        self.readerVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(qrView)
        }
        //self.readerVC.modalPresentationStyle = .formSheet
        self.readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let staffId = result?.value, let couponId = self.coupon?.ID {
                if let staffID = Int(staffId){
                    APIManager.useCoupon(couponId: couponId, staffId: staffID, completion: { (status, message, error) in
                        if error == nil {
                            let configurationVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfigurationVC") as! ConfigurationVC
                            configurationVC.coupon = self.coupon
                            _ = self.navigationController?.pushViewController(configurationVC, animated: true)
                        }
                        else {
                            self.showMessage(message: error ?? "WTH???")
                        }
                    })
                }

            }
            else {
                print("staffId error!!!")
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
    }


    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func findAnotherCouponButtonTapped(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func showCouponWalletTapped(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

}
// NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowVi"), object: showViCoupon, userInfo: nil)
