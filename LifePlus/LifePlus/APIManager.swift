//  APIManager.swift
//  LifePlus
//
//  Created by Ninh Vo on 5/15/17.
//  Copyright © 2017 Ninh Vo. All rights reserved.

import Foundation
import UIKit
import SwiftyJSON
import ObjectMapper
import Alamofire


class APIManager {
    class func requestAPI(router: Router, completion: @escaping (_ response: JSON?, _ error: ApiError?) -> Void) {
        request(router).validate().responseJSON { (response) in
            switch response.result {
            case .success(let json):
                let responseJSON = JSON(json)
                //print(response)
                completion(responseJSON, nil)
                break
            case .failure(_):
                if let data = response.data,
                    let apiError = Mapper<ApiError>().map(JSON: JSON(data).rawValue as! [String : Any]) {
                    completion(nil, apiError)
                }
                else{
                    completion(nil, ApiError())
                }
                break
            }
        }
    }


    class func login(username: String, password: String, completion: @escaping (_ success: Bool, _ user: User?, _ error: String?) -> Void) {
        let router = Router.login(username, password)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response {
                    if let responseDic = response.rawValue as? NSDictionary {
                        if let data = responseDic.value(forKey: "Data") as? [String: Any]{
                            let user = Mapper<User>().map(JSON: data)
                            completion(true, user, nil)
                        }
                    }
                }
            }
            else {
                var errorMsg    = error?.message
                if let error    = error,
                    let msg     = error.message {
                    errorMsg    = msg
                }
                completion(false, nil, errorMsg)
            }
        }
    }


    class func getMerchants (name: String, size: Int, completion: @escaping (_ success: Bool, _ merchants: [Merchant]?,_ nextURL: String?, _ error: String?) -> Void){
        let router = Router.getMerchants(name: name, size: size)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response {
                    if let responseDic = response.rawValue as? NSDictionary {
                        if let data = responseDic.value(forKey: "Data") as? NSArray {
                            let merchants = Mapper<Merchant>().mapArray(JSONArray: data as! [[String : Any]])
                            var nextURL: String?
                            if let pagination = responseDic["Pagination"] as? NSDictionary {
                                if let next = pagination["NextUrl"] as? String {
                                    nextURL = next
                                }
                            }
                            completion(true, merchants, nextURL , nil)
                            return
                        }
                    }
                }

            }
            else {
                var errorMsg    = error?.message
                if let error    = error,
                    let msg     = error.message {
                    errorMsg    = msg
                }
                completion(false, nil, nil, errorMsg)
            }
        }
    }


    class func getMoreMerchants(nextURL: String, completion: @escaping (_ sucess: Bool, _ merchant: [Merchant]?, _ nextURL: String?, _ error: String?) -> Void)  {
        let router = Router.getMoreMerchants(nextURL: nextURL)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response {
                    if let responseDict = response.rawValue as? NSDictionary {
                        if let data = responseDict.value(forKey: "Data") as? NSArray {
                            let merchants = Mapper<Merchant>().mapArray(JSONArray: data as! [[String: Any]])
                            var nextURL: String?
                            if let pagination = responseDict["Pagination"] as? NSDictionary {
                                if let next = pagination["NextUrl"] as? String {
                                    nextURL = next
                                }
                                else {
                                    print("next error")
                                }
                            }
                            else {
                                print("pagination erro???")
                            }
                            completion(true, merchants, nextURL, nil)
                            return
                        }
                        else {
                            print("data error???")
                        }
                    }
                    else {
                        print("responseDict error???")
                    }
                }
                else {
                    print("response error???")
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message {
                    errorMsg = msg
                }
                else {
                    print("error???")
                }
                completion(false, nil, nil, errorMsg)
            }
        }
    }


    class func signUp(email: String,
                      password:     String,
                      phone:        String,
                      name:         String,
                      merchantId:   String,
                      completion:   @escaping (_ success: Bool, _ user: User?,_ error: String?) -> Void) {
        let router = Router.signUp(email, password, phone, name, merchantId)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response {
                    if let responseDic = response.rawValue as? NSDictionary {
                        if let item = responseDic.value(forKey: "Data") as? [String: Any] {
                            let user = Mapper<User>().map(JSON: item)
                            completion(true, user, nil)
                        }
                    }
                }
            }
            else {
                var errorMsg    = error?.message
                if let error    = error,
                    let msg     = error.message {
                    errorMsg    = msg
                }
                completion(false, nil, errorMsg)
            }
        }
    }


    class func activeAccount (activeCode: String,
                              completion: @escaping (_ success: Bool, _ user: User?, _ error: String?) -> Void) {
        let router = Router.activeAccount(activeCode)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response {
                    if let responseDic = response.rawValue as? NSDictionary {
                        if let item = responseDic.value(forKey: "Data") as? NSDictionary {
                            if let user = item.value(forKey: "User") as? [String : Any] {
                                let user = Mapper<User>().map(JSON: user)
                                completion(true, user, nil)
                            }
                        }

                    }
                }
            }
            else {
                var errorMsg    = error?.message
                if let error    = error,
                    let msg     = error.message {
                    errorMsg    = msg
                }
                completion(false, nil, errorMsg)
            }
        }
    }


    class func getCampaigns(groupType: String, size: Int, completion: @escaping (_ success: Bool, _ campaigns: [Campaign]?,_ nextURL: String?, _ error: String?) -> Void) {
        let router = Router.getCampaigns(groupType: groupType, size: size)
        self.requestAPI(router: router) { (response, error) in
            if error != nil {
                var errorMsg    = error?.message
                if let error    = error,
                    let msg     = error.message {
                    errorMsg    = msg
                }
                completion(false, nil, nil, errorMsg)
                return
            }
            if let response = response {
                if let responseDic = response.rawValue as? NSDictionary {
                    if let data = responseDic.value(forKey: "Data") as? [[String: Any]] {
                        let campaigns = Mapper<Campaign>().mapArray(JSONArray: data)
                        var nextUrl: String?
                        if let pagination = responseDic.value(forKey: "Pagination") as? NSDictionary {
                            if let next = pagination["NextUrl"] as? String {
                                nextUrl = next
                            }
                        }
                        completion(true, campaigns, nextUrl, nil)
                    }
                }
            }

        }
    }


    class func getNextCampaigns(nextURL: String, completion: @escaping (_ success: Bool, _ campaigns: [Campaign]?, _ nextURL: String?, _ error: String?) -> Void){
        let router = Router.getMoreCampaigns(nextURL: nextURL)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let responseDic = response?.rawValue as? NSDictionary {
                    if let data = responseDic.value(forKey: "Data") as? NSArray {
                        let campaigns = Mapper<Campaign>().mapArray(JSONArray: data as! [[String: Any]])
                        var nextUrl: String?
                        if let pagination = responseDic.value(forKey: "Pagination") as? NSDictionary {
                            if let next = pagination["NextUrl"] as? String {
                                nextUrl = next
                            }
                        }
                        completion(true, campaigns, nextUrl, nil)

                    }
                }

            }
            else {
                var errorMsg = error?.message
                if let error = error,
                    let msg = error.message {
                    errorMsg = msg
                }
                completion(false, nil, nil, errorMsg)
                return

            }
        }
    }


    class func getBanners(isFeature: Bool, completion: @escaping (_ success: Bool, _ banners: [Campaign]?, _ nextURL: String?, _ error: String? ) -> Void) {
        let router = Router.getBanners(isFeature)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response?.rawValue as? NSDictionary {
                    if let data = response["Data"] as? [[String : Any]] {
                        let banners = Mapper<Campaign>().mapArray(JSONArray: data )
                        var nextURL: String?
                        if let pagination = response["Pagination"] as? [String: Any] {
                            if let nextUrl = pagination["NextUrl"] as? String {
                                nextURL = nextUrl
                            }
                            else {
                                print("NextUrl error!!!")
                            }
                        }
                        else {
                            print("pagination error!!!")
                        }
                        completion(true, banners, nextURL, nil)
                    }
                    else {
                        print("data erorr!!!")
                    }
                }
                else {
                    print("response error!!!")
                }
            }
            else {
                var errorMsg    = error?.message
                if let error    = error,
                    let msg     = error.message {
                    errorMsg    = msg
                }
                completion(false, nil, nil, errorMsg)
            }
        }
    }


    class func loginWithFacebook (facebookToken: String, completion: @escaping (_ success: Bool, _ user: User?, _ error: String?) -> Void) {
        let router = Router.loginFacebook(facebookToken: facebookToken)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response?.rawValue as? NSDictionary {
                    if let data = response["Data"] {
                        let user = Mapper<User>().map(JSON: data as! [String : Any])
                        completion(true, user, nil)
                    }
                }
            }
            else {
                var errorMsg    = error?.message
                if let error    = error, let msg = error.message {
                    errorMsg    = msg
                }
                completion(false, nil, errorMsg)
            }
        }
    }

    class func getCampaign(campaignId: Int, completion: @escaping (_ success: Bool, _ campaign: Campaign?, _ error: String?) -> Void) {
        let router = Router.getCoupon(campaignId)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response?.rawValue as? NSDictionary {
                    if let data = response["Data"] {
                        let campaign = Mapper<Campaign>().map(JSON: data as! [String : Any])
                        completion(true, campaign, nil)
                    }
                    else {
                        print("data error???")
                    }
                }
                else {
                    print("response error???")
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message {
                    errorMsg = msg
                }
                completion(false, nil, errorMsg)
            }
        }
    }


    class func searchCoupons(name: String, completion:@escaping (_ success: Bool, _ coupons: [Campaign]?, _ nextURL: String?, _ error: String?) -> Void){
        let router = Router.searchCoupon(name: name)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let responseDict = response?.rawValue as? NSDictionary {
                    if let data = responseDict["Data"] {
                        let coupons = Mapper<Campaign>().mapArray(JSONArray: data as! [[String: Any]])
                        var nextURL: String?
                        if let pagination = responseDict["Pagination"] as? NSDictionary {
                            if let nextUrl = pagination["NextUrl"] as? String {
                                nextURL = nextUrl
                            }
                            else {
                                print("nextURL nil???")
                            }
                        }
                        else {
                            print("pagination error???")
                        }
                        completion(true, coupons, nextURL, nil)
                    }
                    else {
                        print("data error???")
                    }
                }
                else {
                    print("response error???")
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message {
                    errorMsg = msg
                }
                completion(false, nil, nil, errorMsg)
            }
        }
    }


    class func getMoreSearchCoupons (nextURL: String, completion: @escaping (_ success: Bool, _ coupons: [Campaign]?, _ nextURL: String?, _ error: String?) -> Void){
        let router = Router.getMoreSearchCoupon(nextURL: nextURL)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let responseDict = response?.rawValue as? NSDictionary {
                    if let data = responseDict["Data"]{
                        let coupons = Mapper<Campaign>().mapArray(JSONArray: data as! [[String: Any]])
                        var nextURL: String?
                        if let pagination = responseDict["Pagination"] as? NSDictionary {
                            if let nextLink = pagination["NextUrl"] as? String {
                                nextURL = nextLink
                            }
                            else {
                                print("nextURL nil!!!")
                            }
                        }
                        else {
                            print("pagination error!!!")
                        }
                        completion(true, coupons, nextURL, nil)
                    }
                    else {
                        print("data error!!!")
                    }
                }
                else {
                    print("responseDict error!!!")
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message {
                    errorMsg = msg
                }
                completion(false, nil, nil, errorMsg)
            }
        }
    }


    class func getAMerchant(merchantId: Int, completion: @escaping (_ success: Bool, _ coupon: Merchant?, _ error: String?) -> Void) {
        let router = Router.getAMerchant(merchantId)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response?.rawValue as? NSDictionary {
                    if let data = response["Data"] {
                        let merchant = Mapper<Merchant>().map(JSON: data as! [String : Any])
                        completion(true, merchant, nil)
                    }
                    else {
                        print("data error???")
                    }
                }
                else {
                    print("response error???")
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message {
                    errorMsg = msg
                }
                completion(false, nil, errorMsg)
            }
        }
    }


    class func getCouponSponsoring(merchantId: Int, completion: @escaping (_ success: Bool,_ coupons: [Campaign]?, _ nextURL: String?, _ error: String?) -> Void){
        let router = Router.getCouponSposoring(merchantId)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response?.rawValue as? NSDictionary {
                    if let data = response["Data"] {
                        let coupons = Mapper<Campaign>().mapArray(JSONArray: data as! [[String : Any]])
                        var nextURL: String?
                        if let pagination = response["Pagination"] as? [String: Any]{
                            if let nextLink = pagination["NextUrl"]  as? String {
                                nextURL = nextLink
                            }
                            else {
                                print("nextUrl error!!!")
                            }
                        }
                        else {
                            print("Pagination error!!!")
                        }
                        completion(false, coupons, nextURL, nil)
                    }
                    else {
                        print("data error???")
                    }
                }
                else {
                    print("response error???")
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message {
                    errorMsg = msg
                }
                completion(false, nil, nil, errorMsg)
            }
        }
    }


    class func receiveACoupon(campaignId: Int, completion:@escaping (_ status: String?, _ message:String? ,_ coupon: Coupon?, _ error: String?) -> Void) {
        let router = Router.receiveACoupon(campaignId)
        self.requestAPI(router: router) { (response, error) in
            var status:         String?
            var message:        String?
            var coupon: Coupon?
            if error == nil {
                if let response = response?.rawValue as? NSDictionary {
                    status = response["Status"]  as? String
                    message = response["Message"] as? String
                    if let data = response["Data"] as? [String: Any] {
                        if let coup = data["Coupon"] as? [String: Any] {
                            coupon = Mapper<Coupon>().map(JSON: coup)
                        }
                        else {
                            print("coupon error!!!")
                        }
                    }
                    else {
                        print("data error!!!")
                    }
                    completion(status, message, coupon, nil)
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message {
                    errorMsg = msg
                }
                completion(status, message, coupon, errorMsg)
            }
        }
    }

    class func useCoupon(couponId: Int, staffId: Int, completion: @escaping (_ status: String?, _ message: String?, _ error: String?) -> Void ){
        let router = Router.useCoupon(couponId, staffId)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response?.rawValue as? NSDictionary {
                    var sta: String?
                    var mess: String?
                    if let status = response["Status"] as? String {
                        sta = status
                    }
                    else {
                        print("status erro!!!")
                    }
                    if let message = response["Message"] as? String {
                        mess = message
                    }
                    else {
                        print("message erorr!!!")
                    }
                    completion(sta, mess, nil)
                }
                else {
                    print("response error!!!")
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message{
                    errorMsg = msg
                }
                completion(nil, nil, errorMsg)
            }
        }
    }

    class func getMerchantsCustomer (isCustomer: Bool, completion: @escaping (_ success: Bool, _ merchants: [Merchant]?,_ nextURL: String?, _ error: String?) -> Void){
        let router = Router.getMerchantsCustomer(isCustomer: isCustomer)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response {
                    if let responseDic = response.rawValue as? NSDictionary {
                        if let data = responseDic.value(forKey: "Data") as? NSArray {
                            let merchants = Mapper<Merchant>().mapArray(JSONArray: data as! [[String : Any]])
                            var nextURL: String?
                            if let pagination = responseDic["Pagination"] as? NSDictionary {
                                if let next = pagination["NextUrl"] as? String {
                                    nextURL = next
                                }
                            }
                            completion(true, merchants, nextURL , nil)
                            return
                        }
                    }
                }
            }
            else {
                var errorMsg    = error?.message
                if let error    = error,
                    let msg     = error.message {
                    errorMsg    = msg
                }
                completion(false, nil, nil, errorMsg)
            }
        }
    }


    class func receiveCouponAuto(campaignId: Int, branchId: Int, completion: @escaping(_ status: String, _ message: String, _ coupon: Coupon?, _ error: String?) -> Void) {
        let router = Router.receiveCouponAuto(campaignId: campaignId, branchId: branchId)
        self.requestAPI(router: router) { (response, error) in
            var status:         String?
            var message:        String?
            if error == nil {
                if let response = response?.rawValue as? NSDictionary {
                    status = response["Status"]  as? String
                    message = response["Message"] as? String
                    if let data = response["Data"] as? [String: Any] {
                        if let coup = data["Coupon"] as? [String: Any] {
                            let coupon = Mapper<Coupon>().map(JSON: coup)
                            completion(status!, message!, coupon, nil)
                        }
                        else {
                            print("coupon error!!!")
                        }
                    }
                    else {
                        print("data error!!!")
                    }
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message {
                    errorMsg = msg
                }
                completion(status ?? "", message ?? "", nil, errorMsg)
            }
        }
    }


    class func getCard(merchantId: Int, completion: @escaping(_ status: String, _ card: Card?, _ error: String?) -> Void) {
        let router = Router.getCard(merchantId: merchantId)
        self.requestAPI(router: router) { (response, error) in
            var status: String?
            if error == nil {
                if let response = response?.rawValue as? NSDictionary {
                    status = response["Status"] as? String
                    if let data = response["Data"] as? [String: Any] {
                        let card = Mapper<Card>().map(JSON: data)
                        completion(status ?? "status error!!!", card, nil)
                        return
                    }
                    else {
                        completion("data error!!!", nil, nil)
                        return
                    }
                }
                else {
                    completion("response error!!!", nil, nil)
                    return
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message {
                    errorMsg = msg
                }
                completion(status ?? "Status erro!!!", nil, errorMsg)
                return
            }
        }
    }

    class func getGifts(campaignType: String, merchantId: Int, completion: @escaping(_ status: String, _ gifts: [Campaign]?, _ nextUrl: String?,  _ error: String?) -> Void){
        let router = Router.getGifts(campaignType: campaignType, merchantId: merchantId)
        self.requestAPI(router: router) { (response, error) in
            var status:     String?
            var nextUrl:    String?
            if error == nil {
                if let response = response?.rawValue as? NSDictionary{
                    status = response["Status"] as? String
                    if let paging = response["Pagination"] as? NSDictionary{
                        nextUrl = paging["NextUrl"] as? String
                        if let data = response["Data"] as? [[String: Any]]{
                            let gifts = Mapper<Campaign>().mapArray(JSONArray: data)
                            completion(status ?? "gifts error!!!", gifts, nextUrl, nil)
                            return
                        }
                        else {
                            completion(status ?? "data error!!!", nil, nil, nil)
                            return
                        }
                    }
                    else {
                        completion(status ?? "Pagination error!!!", nil, nil, nil)
                        return
                    }
                }
                else {
                    completion(status ?? "response error!!!", nil, nil, nil)
                    return
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message {
                    errorMsg = msg
                }
                completion(status ?? "status error!!!",nil, nil, errorMsg)
                return
            }
        }
    }

    class func getMoreGifts(nextURL: String, completion: @escaping (_ sucess: Bool, _ gifts: [Campaign]?, _ nextURL: String?, _ error: String?) -> Void) {
        let router = Router.getMoreGifts(nextUrl: nextURL)
        self.requestAPI(router: router) { (response, error) in
            if error == nil {
                if let response = response {
                    if let responseDict = response.rawValue as? NSDictionary {
                        if let data = responseDict.value(forKey: "Data") as? NSArray {
                            let merchants = Mapper<Campaign>().mapArray(JSONArray: data as! [[String: Any]])
                            var nextURL: String?
                            if let pagination = responseDict["Pagination"] as? NSDictionary {
                                if let next = pagination["NextUrl"] as? String {
                                    nextURL = next
                                    completion(true, merchants, nextURL, nil)
                                    return
                                }
                                else {
                                    completion(false, nil, nil, "nextURL error!!!")
                                    return
                                }
                            }
                            else {
                                completion(false, nil, nil, "pagination erro???")
                                return
                            }
                        }
                        else {
                            completion(false, nil, nil, "data erro???")
                            return
                        }
                    }
                    else {
                        completion(false, nil, nil, "responseDict erro???")
                        return
                    }
                }
                else {
                    completion(false, nil, nil, "response erro???")
                    return
                }
            }
            else {
                var errorMsg = error?.message
                if let error = error, let msg = error.message {
                    errorMsg = msg
                }
                else {
                    print("error???")
                }
                completion(false, nil, nil, errorMsg)
            }
        }
    }
    
    
}

