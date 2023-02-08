//
//  MessageListModel.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/25.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class MessageListModel: NSObject {
    
    static let shared: MessageListModel = MessageListModel()
    private override init() {
        super.init()
    }

    /// 消息列明
    ///
    /// - Parameters:
    ///   - params: 参数
    ///   - complete:
    /// - Returns: 
    @discardableResult
    func messageList(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("PushNews/PushList", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("messageList responseDic: \(responseDic)")
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
    
    /// 消息已读状态
    ///
    /// - Parameters:
    ///   - params: 参数列表
    ///   - complete:
    /// - Returns:
    @discardableResult
    func messageReadStatus(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("PushNews/ReadNewsInfo", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("messageReadStatus responseDic: \(responseDic)")
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
    
    /// 删除消息
    ///
    /// - Parameters:
    ///   - params: 参数列表
    ///   - complete:
    /// - Returns:
    @discardableResult
    func messageDelete(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("PushNews/DelPushNews", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("messageDelete responseDic: \(responseDic)")
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
