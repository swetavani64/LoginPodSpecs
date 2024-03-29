//
//
//  SignInViewModel.swift
//  ECommerceBrainvire
//
//  Created by Sweta Vani on 06/04/22.
//

import Foundation
import UIKit
import Firebase

class SignInViewModel: NSObject {
    /*
    let defaults = UserDefaults.standard
    
    private var apiName: WhichApiCall = .checkoutAddress
    func callingHttppApi(dict: [String: Any], apiCall: WhichApiCall, completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["token"] = Defaults.deviceToken
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["websiteId"] = UrlParams.defaultWebsiteId
        requstParams["width"] = UrlParams.width
        if apiCall == .login {
            apiName = .login
            requstParams["username"] = dict["username"]
            requstParams["password"] = dict["password"]
        } else if  apiCall == .createAccount {
            apiName = .createAccount
            requstParams["firstName"] = dict["firstName"]
            requstParams["lastName"] = dict["lastName"]
            requstParams["email"] = dict["email"] ?? "test12345@gmail.com"
            requstParams["isSocial"] = "1"
            requstParams["pictureURL"] = dict["pictureURL"]
            requstParams["password"] = "".random(length: 10)
            requstParams["becomeSeller"] = "0"
             requstParams["socialToken"] = dict["token"]
            requstParams["mobile"] = ""
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "SignInViewController"))
        } else {
            apiName = .forgetPassword
            requstParams["email"] = dict["username"]
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                guard let dict = responseObject as? NSDictionary else {
                    ShowNotificationMessages.sharedInstance.warningView(message: "somethingwentwrong".localized)
                    return
                }
                let responseJSON = JSON(dict)
                if let storeId = responseJSON["storeId"].string, storeId != "0" {
                    self?.defaults.set(storeId, forKey: "storeId")
                }
                self?.doFurtherProcessingWithResult(data: responseJSON) { success in
                    completion(success)
                }
            } else if success == 2 {
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi(dict: dict, apiCall: apiCall) {success in
                    completion(success)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        
        if apiName == .login {
            if data["success"].boolValue == true {
                Defaults.customerEmail = data["customerEmail"].stringValue
                Defaults.customerToken = data["customerToken"].stringValue
                Defaults.customerName = data["customerName"].stringValue
                Defaults.newsLetterSubscribe = data["isNewsletterSubscribed"].stringValue
                Defaults.quoteId = "0"//"" sweta changes
                Defaults.profilePicture = data["profileImage"].stringValue
                Defaults.profileBanner = data["bannerImage"].stringValue
                Defaults.cartBadge = data["cartCount"].stringValue
                Defaults.mobileNo = data["mobile"].stringValue
                if data["isAdmin"].intValue == 0 {
                    Defaults.isAdmin = false
                } else {
                    Defaults.isAdmin = true
                }
                if data["isSupplier"].intValue == 0 || data["isPending"].intValue == 1 {
                    Defaults.isSupplier = false
                } else {
                    Defaults.isSupplier = true
                }
                if data["isSeller"].intValue == 0 || data["isPending"].intValue == 1 {
                    Defaults.isSeller = false
                } else {
                    Defaults.isSeller = true
                }
                if data["isPending"].intValue == 0 {
                    self.defaults.set("false", forKey: Defaults.Key.isPending.rawValue)
                } else {
                    self.defaults.set("true", forKey: Defaults.Key.isPending.rawValue)
                }
                
                //MARK:- LOGIN Analytics
                //Analytics.setScreenName("SignIn", screenClass: "SignInViewController.class")
                self.addAnalyticsEvent(eventName: "login", dict: ["id":data["customerToken"].stringValue])
                self.addSelectContentwithNil()
                defaults.synchronize()
                completion(true)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
                completion(false)
            }
        } else if apiName == .createAccount {
                    self.defaults.set(data["customerEmail"].stringValue, forKey: Defaults.Key.customerEmail.rawValue)
                    self.defaults.set(data["customerToken"].stringValue, forKey: Defaults.Key.customerToken.rawValue)
                    self.defaults.set(data["customerName"].stringValue, forKey: Defaults.Key.customerName.rawValue)
                    self.defaults.set(data["mobile"].stringValue, forKey: Defaults.Key.mobileNo.rawValue)
                    self.defaults.set(data["isNewsletterSubscribed"].stringValue, forKey: Defaults.Key.newsLetterSubscribe.rawValue)
            
                    if self.defaults.object(forKey: Defaults.quoteId) != nil {
                        self.defaults.set(nil, forKey: Defaults.quoteId)
                        self.defaults.synchronize()
                    }
                    //UserDefaults.standard.removeObject(forKey: "quoteId")
                    if let profileImage = data["profileImage"].string {
                        self.defaults.set(profileImage, forKey: (Defaults.Key.profilePicture.rawValue))
                    }
                    if let bannerImage  = data["bannerImage"].string {
                        self.defaults.set(bannerImage, forKey: Defaults.Key.profileBanner.rawValue)
                    }
            
                    Defaults.quoteId = ""
                    self.defaults.synchronize()
            
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
                    completion(true)
            } else {
            if data["success"].boolValue {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
            } else {
                ShowNotificationMessages.sharedInstance.showWarningSnackBar(message: data["message"].stringValue)
            }
            completion(true)
        }
    }
     */
}
