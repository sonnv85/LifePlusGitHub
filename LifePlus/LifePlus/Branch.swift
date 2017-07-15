//
//  Branch.swift
//  LifePlus
//
//  Created by Javu on 6/6/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import ObjectMapper

class Branch: Mappable {
    var Id:             Int?
    var Name:           String?
    var Address:        String?
    var Lat:            Double?
    var Lng:            Double?


    required init?(map: Map) {
    }


    func mapping(map: Map) {
        self.Id         <- map["Id"]
        self.Name       <- map["Name"]
        self.Address    <- map["Address"]
        self.Lat        <- map["Lat"]
        self.Lng        <- map["Lng"] 
    }
}
