//
//  Merchant.swift
//  LifePlus
//
//  Created by Javu on 6/6/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import ObjectMapper

class Merchant: Mappable {
    var Id:                     Int?
    var Email:                  String?
    var MerchantName:           String?
    var MerchantLogo:           String?
    var MerchantEmail:          String?
    var Address:                String?
    var Phone:                  String?
    var Lat:                    Double?
    var Lng:                    Double?
    var MerchantType:           String?
    var MerchantDescription:    String?
    var Keyword:                String?
    var Location:               String?
    var TotalCampaign:          Int?
    var Open:                   String?
    var Close:                  String?
    var Image:                  [String]?
    var Website:                String?
    var TotalCampaignGift:      Int?
    var TotalCampaignCoupon:    Int?
    var TotalCustomer:          Int?
    var IsCustomer              = false
    var Branch:                 [Branch]?


    required init?(map: Map) {
    }


    func mapping(map: Map) {
        self.Id                     <- map["Id"]
        self.Email                  <- map["Email"]
        self.MerchantName           <- map["MerchantName"]
        self.MerchantLogo           <- map["MerchantLogo"]
        self.MerchantEmail          <- map["MerchantEmail"]
        self.Address                <- map["Address"]
        self.Phone                  <- map["Phone"]
        self.Lat                    <- map["Lat"]
        self.Lng                    <- map["Lng"]
        self.MerchantType           <- map["MerchantType"]
        self.MerchantDescription    <- map["MerchantDescription"]
        self.Keyword                <- map["Keyword"]
        self.Location               <- map["Location"]
        self.TotalCampaign          <- map["TotalCampaign"]
        self.Open                   <- map["Open"]
        self.Close                  <- map["Close"]
        self.Image                  <- map["Image"]
        self.Website                <- map["Website"]
        self.TotalCampaignGift      <- map["TotalCampaignGift"]
        self.TotalCampaignCoupon    <- map["TotalCampaignCoupon"]
        self.TotalCustomer          <- map["TotalCustomer"]
        self.IsCustomer             <- map["IsCustomer"]
        self.Branch                 <- map["Branch"]

    }
}
