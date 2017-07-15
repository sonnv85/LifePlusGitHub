//
//  APIError.swift
//  Rental App
//
//  Created by Ninh Vo on 8/19/16.
//  Copyright © 2016 IdeaBox. All rights reserved.
//

import Foundation
import ObjectMapper

struct ApiError:    Error, Mappable {
    var status:     String?
    var message:    String? = "Something went wrong!"

    init() { }

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        status      <- map["Status"]
        message     <- map["Message"]
    }
}
