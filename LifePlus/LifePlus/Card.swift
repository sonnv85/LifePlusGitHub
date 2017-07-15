//
//  Card.swift
//  LifePlus
//
//  Created by Javu on 7/10/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import Foundation
import ObjectMapper

class Card: Mappable {
    var Id:             Int?
    var CodeCustomer:   String?
    var PointCard:      Int?
    var RealPointCard:  Int?
    var CreatedAt:      Date?
    var TotalUse:       Int?
    var Image:          String?
    var ExpiredDate:    Date?
    var MemberType:     MemberType?
    var Merchant:       Merchant?
    var Campaigns:      [Campaign]?
    var UserInfo:       User?

    required init?(map: Map) {}

    func mapping(map: Map) {
        self.Id             <- map["Id"]
        self.CodeCustomer   <- map["CodeCustomer"]
        self.PointCard      <- map["PointCard"]
        self.RealPointCard  <- map["RealPointCard"]
        self.CreatedAt      <- (map["CreatedAt"],
                                CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"))
        self.TotalUse       <- map["TotalUse"]
        self.Image          <- map["Image"]
        self.ExpiredDate    <- (map["ExpiredDate"],
                                CustomDateFormatTransform(formatString:"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"))
        self.MemberType     <- map["MemberType"]
        self.Merchant       <- map["Merchant"]
        self.Campaigns      <- map["Campaigns"]
        self.UserInfo       <- map["UserInfo"]
    }
}
