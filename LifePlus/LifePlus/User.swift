//
//  User.swift
//  LifePlus
//
//  Created by Javu on 6/5/17.
//  Copyright © 2017 Javu. All rights reserved.
//

import UIKit
import ObjectMapper

class User: NSObject, Mappable, NSCoding {
    var AccessToken:        String?
    var Email:              String?
    var PointLifeplus:      Int?
    var RealPointLifeplus:  Int?
    var FirstName:          String?
    var LastName:           String?
    var Username:           String?
    var Location:           String?
    var Gender:             String?
    var Phone:              String?
    var Avatar:             String?
    var Lang:               String?
    var Birthday:           String?
    var Address:            String?
    var StringBirthday:     String?
    var TotalReward:        Int?
    var TotalCouponUse:     Int?
    var TotalGiftUse:       Int?


    required init(coder aDecoder: NSCoder) {
        self.AccessToken        = aDecoder.decodeObject(forKey:     "AccessToken")      as? String ?? ""
        self.Email              = aDecoder.decodeObject(forKey:     "Email")            as? String ?? ""
        self.PointLifeplus      = aDecoder.decodeInteger(forKey:    "PointLifeplus")
        self.RealPointLifeplus  = aDecoder.decodeInteger(forKey:    "RealPointLifeplus")
        self.FirstName          = aDecoder.decodeObject(forKey:     "FirstName")        as? String ?? ""
        self.LastName           = aDecoder.decodeObject(forKey:     "LastName")         as? String ?? ""
        self.Username           = aDecoder.decodeObject(forKey:     "User")             as? String ?? ""
        self.Location           = aDecoder.decodeObject(forKey:     "Location")         as? String ?? ""
        self.Gender             = aDecoder.decodeObject(forKey:     "Gender")           as? String ?? ""
        self.Phone              = aDecoder.decodeObject(forKey:     "Phone")            as? String ?? ""
        self.Avatar             = aDecoder.decodeObject(forKey:     "Avatar")           as? String ?? ""
        self.Lang               = aDecoder.decodeObject(forKey:     "Lang")             as? String ?? ""
        self.Birthday           = aDecoder.decodeObject(forKey:     "Birthday")         as? String ?? ""
        self.Address            = aDecoder.decodeObject(forKey:     "Address")          as? String ?? ""
        self.StringBirthday     = aDecoder.decodeObject(forKey:     "StringBirthday") as? String ?? ""
        self.TotalReward        = aDecoder.decodeInteger(forKey:    "TotalReward")
        self.TotalCouponUse     = aDecoder.decodeInteger(forKey:    "TotalCouponUse")
        self.TotalGiftUse       = aDecoder.decodeInteger(forKey:    "TotalGiftUse")
    }


    func encode(with aCoder: NSCoder) {
        aCoder.encode(AccessToken, forKey:          "AccessToken")
        aCoder.encode(Email, forKey:                "Email")
        aCoder.encode(PointLifeplus, forKey:        "PointLifeplus")
        aCoder.encode(RealPointLifeplus, forKey:    "RealPointLifeplus")
        aCoder.encode(FirstName, forKey:            "FirstName")
        aCoder.encode(LastName, forKey:             "LastName")
        aCoder.encode(Username, forKey:             "Username")
        aCoder.encode(Location, forKey:             "Location")
        aCoder.encode(Gender, forKey:               "Gender")
        aCoder.encode(Phone, forKey:                "Phone")
        aCoder.encode(Avatar, forKey:               "Avatar")
        aCoder.encode(Lang, forKey:                 "Lang")
        aCoder.encode(Birthday, forKey:             "Birthday")
        aCoder.encode(Address, forKey:              "Address")
        aCoder.encode(StringBirthday, forKey:       "StringBirthday")
        aCoder.encode(TotalReward, forKey:          "TotalReward")
        aCoder.encode(TotalCouponUse, forKey:       "TotalCouponUse")
        aCoder.encode(TotalGiftUse, forKey:         "TotalGiftUse")
    }


    required init?(map: Map) {
    }


    func save() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self.toJSON())
        UserDefaults.standard.set(data, forKey: "user")
        UserDefaults.standard.synchronize()
    }


    class func currentUser() -> User? {
        let data = UserDefaults.standard.object(forKey: "user") as? Data
        if let dataUser = data {
            if let user = NSKeyedUnarchiver.unarchiveObject(with: dataUser) as? [String: Any] {
                return User(JSON: user)
            }
        }
        return nil
    }

    
    func mapping(map: Map) {
        self.AccessToken         <- map["AccessToken"]
        self.Email               <- map["Email"]
        self.PointLifeplus       <- map["PointLifeplus"]
        self.RealPointLifeplus   <- map["RealPointLifeplus"]
        self.FirstName           <- map["FirstName"]
        self.LastName            <- map["LastName"]
        self.Username            <- map["Username"]
        self.Location            <- map["Location"]
        self.Gender              <- map["Gender"]
        self.Phone               <- map["Phone"]
        self.Avatar              <- map["Avatar"]
        self.Lang                <- map["Lang"]
        self.Birthday            <- map["Birthday"]
        self.Address             <- map["Address"]
        self.StringBirthday      <- map["StringBirthday"]
        self.TotalReward         <- map["TotalReward"]
        self.TotalCouponUse      <- map["TotalCouponUse"]
        self.TotalGiftUse        <- map["TotalGiftUse"]
    }
}
