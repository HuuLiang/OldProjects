//
//  UserLoginModel.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/22.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class UserLoginModel: NSObject {
    
    static let shared: UserLoginModel = UserLoginModel()
    private override init() {
        super.init()
    }
    
    func requestVerifyCode(_ params: [String: String], complete: @escaping (_ error: CMCError?) -> Void) -> Void {
    
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")

        CMCRequestManager.sharedClient().post("Captcha/send", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            
            log.info("responseDic:\(responseDic)")
            
            if responseDic == nil {
                complete(CMCError.jsonSerializedFailed)
            }
            else {
                //complete(nil)
                let (_, error) = ConverNetworkResponse(responseData: responseDic as! [String : AnyObject])
                complete(error)
            }
        }) { (sessionData, error) in
            complete(CMCError.converResponseError(error: error as NSError))
        }
    }
    
    // 登录
    func login(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> Void {
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(String(describing: versionParams))")
        
        CMCRequestManager.sharedClient().post("user/login", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            
            log.info("responseDic:\(String(describing: responseDic))")
            
            if responseDic == nil {
                complete(nil, CMCError.jsonSerializedFailed)
            }
            else {
                let (result, error) = ConverNetworkResponse(responseData: responseDic as! [String : AnyObject])
                complete(result, error)
            }
        }) { (sessionData, error) in
            complete(nil, CMCError.converResponseError(error: error as NSError))
        }
    }
    
    /// 提交设备信息
    ///
    /// - Parameters:
    ///   - params:
    ///   - complete:
    func postUserDeviceInfo(_ params: [String: String], complete: @escaping (_ error: CMCError?) -> Void) -> Void {
        
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        CMCRequestManager.sharedClient().post("user/getUserDevice", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            
            log.info("postUserDeviceInfo:\(responseDic)")
            
            if responseDic == nil {
                complete(CMCError.jsonSerializedFailed)
            }
            else {
                //complete(nil)
                let (_, error) = ConverNetworkResponse(responseData: responseDic as! [String : AnyObject])
                complete(error)
            }
            
        }) { (sessionData, error) in
            complete(CMCError.converResponseError(error: error as NSError))
        }
    }
    
    /// 获取商家信息
    ///
    /// - Parameters:
    ///   - params:
    ///   - complete:
    func userShopInfo(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> Void {
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        CMCRequestManager.sharedClient().post("User/shopInfo", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            
            log.info("responseDic:\(responseDic)")
            
            if responseDic == nil {
                complete(nil, CMCError.jsonSerializedFailed)
            }
            else {
                let (result, error) = ConverNetworkResponse(responseData: responseDic as! [String : AnyObject])
                complete(result, error)
            }
        }) { (sessionData, error) in
            complete(nil, CMCError.converResponseError(error: error as NSError))
        }
    }
    
    /// 获取店铺列表
    ///
    /// - Parameters:
    ///   - params:
    ///   - complete:
    /// - Returns:
    func userShopLists(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("userShopLists versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("user/shopLists", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("userShopLists responseDic: \(responseDic)")
            //log.info("orderList url string" + (sessionTask.currentRequest?.url?.absoluteString ?? ""))
            if responseDic == nil {
                complete(nil, CMCError.jsonSerializedFailed)
            }
            else {
                let (result, error) = ConverNetworkResponse(responseData: responseDic as! [String : AnyObject])
                complete(result, error)
            }
        }) { (sessionData, error) in
            complete(nil, CMCError.converResponseError(error: error as NSError))
        }
    }
}
