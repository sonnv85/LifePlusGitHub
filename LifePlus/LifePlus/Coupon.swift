//
//  Coupon.swift
//  LifePlus
//
//  Created by Javu on 6/5/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import ObjectMapper

class Coupon: Mappable {
    
    var ID:                     Int?
    var UserMerchantId:         Int?
    var CampaignId:             Int?
    var CardId:                 Int?
    var UserId:                 Int?
    var IsClaimed =             false
    var DeviceId:               Int?
    var CreatedAt:              Date?
    var UpdatedAt:              Date?
    var BranchId:               Int?
    var Status:                 Int?
    var EmployeeId:             Int?
    var Code:                   String?
    var PointUse:               Int?
    var TradeAt:                Date?
    var Amount:                 Int?
    var Rate:                   Int?


    required init?(map: Map) {
    }


    func mapping(map: Map) {
        ID              <- map["ID"]
        UserMerchantId  <- map["UserMerchantId"]
        CampaignId      <- map["CampaignId"]
        CardId          <- map["CardId"]
        UserId          <- map["UserId"]
        IsClaimed       <- map["IsClaimed"]
        DeviceId        <- map["DeviceId"]
        CreatedAt       <- (map["CreatedAt"], CustomDateFormatTransform(formatString: "yyyy-mm-dd'T'hh:mm:ss.sssssssss'+'HH:MM"))
        UpdatedAt       <- (map["UpdatedAt"], CustomDateFormatTransform(formatString: "yyyy-mm-dd'T'hh:mm:ss.sssssssss'+'HH:MM"))
        BranchId        <- map["BranchId"]
        Status          <- map["Status"]
        EmployeeId      <- map["EmployeeId"]
        Code            <- map["Code"]
        PointUse        <- map["PointUse"]
        TradeAt         <- (map["TradeAt"], CustomDateFormatTransform(formatString: "yyyy-mm-dd'T'hh:mm:ss'Z'"))
        Amount          <- map["Amount"]
        Rate            <- map["Rate"]

    }
}
