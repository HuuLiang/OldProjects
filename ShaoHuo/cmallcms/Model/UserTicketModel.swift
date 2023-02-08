//
//  UserTicketModel.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/19.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import ObjectMapper

enum LoginType: Int {
        case phone = 0
        case account = 1
}

struct UserTicketModel {
    
    static var sharedInstance = UserTicketModel()
    fileprivate init() {
        
    }
    // 店铺列表
    var shop_list: [ShopItemEntity] = []
    // 登录类型
    var login_type: LoginType {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "USER_LOGIN_TYPE")
        }
        get {
            return LoginType(rawValue: UserDefaults.standard.integer(forKey: "USER_LOGIN_TYPE")) ?? .phone
        }
    }
    
    // 用户编号
    var uid: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_ID")
            //NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "USER_ID")
        }
    }
    /// 用户手机号码
//    var mobile_phone: String? {
//        set {
//            UserDefaults.standard.set(newValue, forKey: "USER_PHONE")
//            //NSUserDefaults.standardUserDefaults().synchronize()
//        }
//        get {
//            return UserDefaults.standard.string(forKey: "USER_PHONE")
//        }
//    }
    // 用户Token
    var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_TOKEN")
            //NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "USER_TOKEN")
        }
    }
    
    var address: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_ADDRESS")
            //NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "USER_ADDRESS")
        }
    }
    
    var region_id: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_REGION_ID")
            //NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "USER_REGION_ID")
        }
    }
    
    var shop_id: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_SHOP_ID")
            //NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "USER_SHOP_ID")
        }
    }
    
    var username: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_USERNAME")
            //NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "USER_USERNAME")
        }
    }
    
    var alias: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_ALIAS")
            //NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "USER_ALIAS")
        }
    }
    
    var mobile_phone: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_MOBILE_PHONE")
            //NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "USER_MOBILE_PHONE")
        }
    }
    
    var account: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_ACCOUNT")
            //NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "USER_ACCOUNT")
        }
    }
    
    var shop_name: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_SHOPNAME")
            //NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "USER_SHOPNAME")
        }
    }
    
    var user_type: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "USER_USER_TYPE")
            //NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "USER_USER_TYPE")
        }
    }

    var isLogin: Bool {
        get {
            return self.uid == nil ? false : true
        }
    }
    // 退出登录
    func logout() -> Void {
        
        if let tmpAlias = alias {
            UMessage.removeAlias(tmpAlias, type: "ishaohuo") { (result, error) in
                log.info("responseObject: \(result)")
            }
        }
        
        UserDefaults.standard.removeObject(forKey: "USER_ID")
        UserDefaults.standard.removeObject(forKey: "USER_TOKEN")
        
        UserDefaults.standard.removeObject(forKey: "USER_SHOPNAME")
        UserDefaults.standard.removeObject(forKey: "USER_ACCOUNT")
        UserDefaults.standard.removeObject(forKey: "USER_MOBILE_PHONE")
        UserDefaults.standard.removeObject(forKey: "USER_ALIAS")
        //USER_USERNAME
        UserDefaults.standard.removeObject(forKey: "USER_USERNAME")
        //USER_SHOP_ID
        UserDefaults.standard.removeObject(forKey: "USER_SHOP_ID")
        
        //self.shop_list.removeAll()
        UserTicketModel.sharedInstance.shop_list.removeAll()
    }
    
    /// 是否第一次启动应用
    ///
    /// - Returns: true false
    func isFirstLaunch() -> Bool {
        if UserDefaults.standard.bool(forKey: "USER_IS_FIRST_LAUNCH") == false {
            UserDefaults.standard.set(true, forKey: "USER_IS_FIRST_LAUNCH")
            return true
        }
        return false
    }

}
