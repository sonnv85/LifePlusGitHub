//
//  MemberType.swift
//  LifePlus
//
//  Created by Javu on 6/6/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import ObjectMapper

class MemberType: Mappable {

    var Id:             Int?
    var Name:           String?
    var Description:    String?
    var Image:          String?
    var ColorHex:       String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        self.Id             <- map["Id"]
        self.Name           <- map["Name"]
        self.Description    <- map["Description"]
        self.Image          <- map["Image"]
        self.ColorHex       <- map["ColorHex"]
    }
}
