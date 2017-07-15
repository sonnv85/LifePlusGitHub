//
//  Campaign.swift
//  LifePlus
//
//  Created by Javu on 6/6/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import ObjectMapper

class Campaign: Mappable {

    var Id:                     Int?
    var Name:                   String?
    var Description:            String?
    var CreatedAt:              Date?
    var StartDate:              Date?
    var EndDate:                Date?
    var Banner:                 String?
    var TypeCampaign:           String?
    var GroupCampaign:          String?
    var Distance:               Double?
    var TotalAmount:            Int?
    var RewardAmount:           Int?
    var View:                   Int?
    var QRCode:                 String?
    var TotalPointCampaign:     Int?
    var IsLogin                 = false
    var HasSurvey               = false
    var ReceiveCampaign:        String?
    var IsReceive               = false
    var IsReused                = false
    var PointUse:               Int?
    var Merchant:               Merchant?
    var MemberType:             MemberType?
    var Branch:                 [Branch]?


    required init?(map: Map) {
    }


    func mapping(map: Map) {
        self.Id                 <- map["Id"]
        self.Name               <- map["Name"]
        self.Description        <- map["Description"]
        self.CreatedAt          <- (map["CreatedAt"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"))
        self.StartDate          <- (map["StartDate"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss'Z'"))
        self.EndDate            <- (map["EndDate"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss'Z'"))
        self.Banner             <- map["Banner"]
        self.TypeCampaign       <- map["TypeCampaign"]
        self.GroupCampaign      <- map["GroupCampaign"]
        self.Distance           <- map["Distance"]
        self.TotalAmount        <- map["TotalAmount"]
        self.RewardAmount       <- map["RewardAmount"]
        self.View               <- map["View"]
        self.QRCode             <- map["QRCode"]
        self.TotalPointCampaign <- map["TotalPointCampaign"]
        self.IsLogin            <- map["IsLogin"]
        self.HasSurvey          <- map["HasSurvey"]
        self.ReceiveCampaign    <- map["ReceiveCampaign"]
        self.IsReceive          <- map["IsReceive"]
        self.IsReused           <- map["IsReused"]
        self.PointUse           <- map["PointUse"]
        self.Merchant           <- map["Merchant"]
        self.MemberType         <- map["MemberType"]
        self.Branch             <- map["Branch"]
    }
}
