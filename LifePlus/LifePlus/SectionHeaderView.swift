//
//  SectionHeaderMenuVC.swift
//  LifePlus
//
//  Created by Javu on 6/19/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

    @IBOutlet weak var foodView:        UIView!
    @IBOutlet weak var foodImageView:   UIImageView!
    @IBOutlet weak var foodLabel:       UILabel!
    @IBOutlet weak var foodPlusImage:   UIImageView!
    @IBOutlet weak var foodButton:      UIButton!

    @IBOutlet weak var buyView:         UIView!
    @IBOutlet weak var buyImageView:    UIImageView!
    @IBOutlet weak var buyLabel:        UILabel!
    @IBOutlet weak var buyPlusImageView: UIImageView!
    @IBOutlet weak var buyButton:       UIButton!

    @IBOutlet weak var placeView:       UIView!
    @IBOutlet weak var placeImageView:  UIImageView!
    @IBOutlet weak var placeLabel:      UILabel!
    @IBOutlet weak var placePlusImageView: UIImageView!
    @IBOutlet weak var placeButton:     UIButton!

    var didSelectSegment: ((String) -> Void)?

    func configUI(selectedTabIndex: Int) {
        switch selectedTabIndex {
        case 0:
            self.setupUI(currentView: self.foodView,
                         currentViewImage: self.foodImageView,
                         currentViewlabel: self.foodLabel,
                         currentViewplusImage: self.foodPlusImage,

                         view1: self.buyView,
                         view1Image: self.buyImageView,
                         label1: self.buyLabel,
                         plusImage1: self.buyPlusImageView,

                         view2: self.placeView,
                         view2Image: self.placeImageView,
                         label2: self.placeLabel,
                         plusImage2: self.placePlusImageView)
            break
        case 1:
            self.setupUI(currentView: self.buyView,
                         currentViewImage: self.buyImageView,
                         currentViewlabel: self.buyLabel,
                         currentViewplusImage: self.buyPlusImageView,

                         view1: self.foodView,
                         view1Image: self.foodImageView,
                         label1: self.foodLabel,
                         plusImage1: self.foodPlusImage,

                         view2: self.placeView,
                         view2Image: self.placeImageView,
                         label2: self.placeLabel,
                         plusImage2: self.placePlusImageView)
            break
        default:
            self.setupUI(currentView: self.placeView,
                         currentViewImage: self.placeImageView,
                         currentViewlabel: self.placeLabel,
                         currentViewplusImage: self.placePlusImageView,

                         view1: self.buyView,
                         view1Image: self.buyImageView,
                         label1: self.buyLabel,
                         plusImage1: self.buyPlusImageView,

                         view2: self.foodView,
                         view2Image: self.foodImageView,
                         label2: self.foodLabel,
                         plusImage2: self.foodPlusImage)
            break
        }
    }


    @IBAction func foodButtonTapped(_ sender: Any?) {
        self.setupUI(currentView: self.foodView,
                     currentViewImage: self.foodImageView,
                     currentViewlabel: self.foodLabel,
                     currentViewplusImage: self.foodPlusImage,

                     view1: self.buyView,
                     view1Image: self.buyImageView,
                     label1: self.buyLabel,
                     plusImage1: self.buyPlusImageView,

                     view2: self.placeView,
                     view2Image: self.placeImageView,
                     label2: self.placeLabel,
                     plusImage2: self.placePlusImageView)
        self.didSelectSegment?("food")
    }

    @IBAction func buyButtonTapped(_ sender: Any?) {
        self.setupUI(currentView: self.buyView,
                     currentViewImage: self.buyImageView,
                     currentViewlabel: self.buyLabel,
                     currentViewplusImage: self.buyPlusImageView,

                     view1: self.foodView,
                     view1Image: self.foodImageView,
                     label1: self.foodLabel,
                     plusImage1: self.foodPlusImage,

                     view2: self.placeView,
                     view2Image: self.placeImageView,
                     label2: self.placeLabel,
                     plusImage2: self.placePlusImageView)
        self.didSelectSegment?("buy")
    }

    @IBAction func placeButtonTapped(_ sender: Any?) {
        self.setupUI(currentView: self.placeView,
                     currentViewImage: self.placeImageView,
                     currentViewlabel: self.placeLabel,
                     currentViewplusImage: self.placePlusImageView,

                     view1: self.buyView,
                     view1Image: self.buyImageView,
                     label1: self.buyLabel,
                     plusImage1: self.buyPlusImageView,

                     view2: self.foodView,
                     view2Image: self.foodImageView,
                     label2: self.foodLabel,
                     plusImage2: self.foodPlusImage)
        self.didSelectSegment?("place")
    }

    func setupUI(currentView: UIView, currentViewImage: UIImageView, currentViewlabel: UILabel, currentViewplusImage: UIImageView, view1: UIView,view1Image: UIImageView, label1: UILabel, plusImage1: UIImageView ,view2: UIView, view2Image: UIImageView, label2: UILabel, plusImage2: UIImageView) {

        currentView.backgroundColor = UIColor.init(red: 80 / 255.0, green: 200 / 255.0, blue: 90 / 255.0, alpha: 1.0)
        view1.backgroundColor       = UIColor.init(red: 220 / 255.0, green: 220 / 255.0, blue: 220 / 255.0, alpha: 0.3)
        view2.backgroundColor       = UIColor.init(red: 220 / 255.0, green: 220 / 255.0, blue: 220 / 255.0, alpha: 0.3)

        let currImage               = currentViewImage.image?.withRenderingMode(.alwaysTemplate)
        currentViewImage.image      = currImage
        currentViewImage.tintColor  = UIColor.white

        let v1Image                 = view1Image.image?.withRenderingMode(.alwaysTemplate)
        view1Image.image            = v1Image
        view1Image.tintColor        = UIColor.gray

        let v2Image                 = view2Image.image?.withRenderingMode(.alwaysTemplate)
        view2Image.image            = v2Image
        view2Image.tintColor        = UIColor.gray

        currentViewlabel.textColor  = UIColor.white
        label1.textColor            = UIColor.gray
        label2.textColor            = UIColor.gray

        currentViewplusImage.isHidden = false
        plusImage1.isHidden         = true
        plusImage2.isHidden         = true
    }
}
