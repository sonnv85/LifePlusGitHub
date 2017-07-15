//
//  Router.swift
//  LifePlus
//
//  Created by Ninh Vo on 5/15/17.
//  Copyright © 2017 Ninh Vo. All rights reserved.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString        = "https://dev-api.lifeplusloyalty.vn/"

    static let apiLogin             = "user"
    case login(String, String)

    static let apiMerchant          = "merchant"
    case getMerchants(name: String, size: Int)
    case getMoreMerchants(nextURL: String)

    static let apiSignUp            = "merchant/:ID/signup"
    case signUp(String, String, String, String, String)

    static let apiActive            = "user/activated"
    case activeAccount(String)

    static let apiGetCampaigns      = "campaign"
    case getCampaigns(groupType: String, size: Int)
    case getMoreCampaigns(nextURL: String)

    static let apigetBanners        = "campaign"
    case getBanners(Bool)

    static let apiLoginFacebook     = "user/signin/facebook"
    case loginFacebook(facebookToken: String)

    static let apiGetCoupon         = "campaign/:ID"
    case getCoupon(Int)

    static let apiSearchCoupon      = "campaign"
    case searchCoupon(name: String)
    case getMoreSearchCoupon(nextURL: String)

    static let apiGetCouponSponsoring  = "campaign"
    case getCouponSposoring(Int)
    case getMoreCouponSposoring(String)

    static let apiGetAMerchant      = "merchant/:ID"
    case getAMerchant(Int)

    static let apiReceiveACoupon    = "campaign/:ID/receive"
    case receiveACoupon(Int)

    static let apiUseCoupon         = "coupon/:CouponId/:StaffId/use" //Reject
    case useCoupon(Int, Int)

    static let apiGetMerchantsCustomer = "merchant"
    case getMerchantsCustomer(isCustomer: Bool)

    static let apiReceiveCouponAuto = "campaign/:ID/receive_auto_register_customer"
    case receiveCouponAuto(campaignId: Int, branchId: Int)

    static let apiGetCard           = "merchant/:ID/card"
    case getCard(merchantId: Int)

    static let apiGetGifts          = "campaign"
    case getGifts(campaignType: String, merchantId: Int)
    case getMoreGifts(nextUrl: String)

    /*------------------------------------------------------------------------*/

    var method: HTTPMethod {
        switch self {
        case .login(_,_),
             .signUp(_, _, _, _, _),
             .activeAccount(_),
             .loginFacebook(facebookToken: _),
             .receiveACoupon(_),
             .useCoupon(_, _),
             .receiveCouponAuto(campaignId: _, branchId: _):
            return .post
        case .getMerchants(_, _),
             .getCampaigns(_, _),
             .getBanners,
             .getMoreCampaigns(_),
             .getMoreMerchants(_),
             .getCoupon(_),
             .searchCoupon(name: _),
             .getMoreSearchCoupon(nextURL: _),
             .getCouponSposoring(_),
             .getMoreCouponSposoring(nextURL: _),
             .getAMerchant(_),
             .getMerchantsCustomer(isCustomer: _),
             .getCard(merchantId: _),
             .getGifts(campaignType: _, merchantId: _),
             .getMoreGifts(nextUrl: _):
            return .get
        }
    }

/*------------------------------------------------------------------------*/

    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters?) = {
            switch self {
            case .login(let username, let password):
                return (Router.apiLogin, ["Username": username, "Password": password])

            case .getMerchants(let name, let size):
                return (Router.apiMerchant, ["name": name, "size": size])

            case .signUp(let email, let password, let phone, let name, let merchantId):
                return(Router.apiSignUp.replacingOccurrences(of: ":ID", with: merchantId), ["Email": email, "Password": password, "Phone" : phone, "Name": name])

            case .activeAccount(let activeCode):
                return (Router.apiActive, ["ActivateCode": activeCode])

            case .getCampaigns(let groupType, let size):
                return (Router.apiGetCampaigns, ["group": groupType, "size": size])

            case .getMoreCampaigns(let nextURL):
                return (nextURL, nil)

            case .getBanners(let isFeature):
                return (Router.apigetBanners, ["isFeature": isFeature])

            case .loginFacebook(let facebookToken):
                return (Router.apiLoginFacebook, ["AccessToken": facebookToken])

            case .getMoreMerchants(let nextURL):
                return (nextURL, nil)

            case .getCoupon(let campaignId):
                return (Router.apiGetCoupon.replacingOccurrences(of: ":ID", with: "\(campaignId)"),nil)

            case .searchCoupon(let name):
                return(Router.apiSearchCoupon, ["name": name])

            case .getMoreSearchCoupon(let nextURL):
                return (nextURL, nil)

            case .getCouponSposoring(let merchantId):
                return (Router.apiGetCouponSponsoring,["merchantId": merchantId])

            case .getMoreCouponSposoring(let nextURL):
                return(nextURL, nil)

            case .getAMerchant(let merchantId):
                return(Router.apiGetAMerchant.replacingOccurrences(of: ":ID", with: "\(merchantId)"), nil)

            case .receiveACoupon(let campaignId):
                return(Router.apiReceiveACoupon.replacingOccurrences(of: ":ID", with: "\(campaignId)"), nil)

            case .useCoupon(let couponId, let staffId):
                return(Router.apiUseCoupon.replacingOccurrences(of: ":CouponId/:StaffId", with: "\(couponId)/\(staffId)"), nil)

            case .getMerchantsCustomer(let isCustomer):
                return(Router.apiGetMerchantsCustomer, ["isCustomer": isCustomer])

            case .receiveCouponAuto(let campaignId, let barnchId):
                return(Router.apiReceiveCouponAuto.replacingOccurrences(of: ":ID", with: "\(campaignId)"),["IdBranch": barnchId])

            case .getCard(let merchantId):
                return(Router.apiGetCard.replacingOccurrences(of: ":ID", with: "\(merchantId)"), nil)

            case .getGifts(let campaignType, let merchantId):
                return(Router.apiGetGifts, ["type": campaignType, "merchantId": merchantId])

            case .getMoreGifts(let nextUrl):
                return(nextUrl, nil)

            }
        }()

        /*------------------------------------------------------------------------*/

        var urlRequest: URLRequest!
        let fullUrl: URL!
        switch self {
        case .getMoreCampaigns(_),
             .getMoreMerchants(nextURL: _),
             .getMoreSearchCoupon(nextURL: _),
             .getMoreCouponSposoring(nextURL: _),
             .getMoreGifts(nextUrl: _):
            //Use to get items by Next URL.
            fullUrl                 = try result.path.asURL()
            urlRequest              = URLRequest(url: fullUrl)
            break
        default:
            //Use to get single item.
            let url                 = try Router.baseURLString.asURL()
            fullUrl                 = url.appendingPathComponent(result.path)
            urlRequest              = URLRequest(url: fullUrl)
        }
        urlRequest!.httpMethod      = self.method.rawValue
        let userToken = User.currentUser()?.AccessToken ?? ""
        urlRequest.setValue(userToken, forHTTPHeaderField: "X-User-Token")

        print("*********************************************")
        print("\(method.rawValue) : \(fullUrl!)")
        print("Header: \(urlRequest!.allHTTPHeaderFields!)")
        print("Parameters: \(result.parameters)")
        print("*********************************************")
        switch self {
        case .signUp(_, _, _, _, _):
            return try JSONEncoding.default.encode(urlRequest, with: result.parameters)
        default:
            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
}
