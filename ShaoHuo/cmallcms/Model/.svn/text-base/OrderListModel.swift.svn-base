//
//  OrderListModel.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/22.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class OrderListModel: NSObject {
    
    static let shared: OrderListModel = OrderListModel()
    private override init() {
        super.init()
    }
    
    /// 获取订单列表
    ///
    /// - Parameters:
    ///   - params: 参数
    ///   - complete: 回调
    /// - Returns:
    @discardableResult
    func orderList(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("order/list", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("orderList responseDic: \(responseDic)")
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
    
    /// 获取订单详情
    ///
    /// - Parameters:
    ///   - params: 参数
    ///   - complete: 回调
    /// - Returns:
    @discardableResult
    func orderDetail(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("order/details", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("orderDetail responseDic: \(responseDic)")
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
    
    /// 获取退款详情
    ///
    /// - Parameters:
    ///   - params:
    ///   - complete:
    /// - Returns:
    @discardableResult
    func orderRefundDetail(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("order/refundDetails", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("orderDetail responseDic: \(responseDic)")
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
    
    /// 取消订单
    ///
    /// - Parameters:
    ///   - params: 参数
    ///   - complete: 回调
    /// - Returns: 返回值
    @discardableResult
    func cancelOrder(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("order/cancel", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("cancelOrder responseDic: \(responseDic)")
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
    
    /// 订单发货
    ///
    /// - Parameters:
    ///   - params:
    ///   - complete: 回调
    /// - Returns:
    @discardableResult
    func orderDelivery(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("order/delivery", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("orderDelivery responseDic: \(responseDic)")
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
    
    
    /// 获取发货物流列表
    ///
    /// - Parameters:
    ///   - params:
    ///   - complete:
    /// - Returns: 
    @discardableResult
    func orderShippingList(params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("order/shippingList", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("orderShippingList responseDic: \(responseDic)")
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
    
    @discardableResult
    func orderRefundDispose(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("order/refundDispose", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("orderRefundDispose responseDic: \(responseDic)")
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
    
    @discardableResult
    func orderBatchDelivery(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("order/batchDelivery", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("orderRefundDispose responseDic: \(responseDic)")
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
    
    /// 首页红点显示
    ///
    /// - Parameters:
    ///   - params: ad_uid  token  shop_id
    ///   - complete:
    /// - Returns:
    @discardableResult
    func getIndexPoint(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("common/getIndexPoint", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("getIndexPoint responseDic: \(responseDic)")
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
    
    /// 增加打印小票次数
    ///
    /// - Parameters:
    ///   - params:
    ///   - complete:
    /// - Returns:
    @discardableResult
    func orderAddReceiptPrintCount(_ params: [String: String], complete: @escaping (_ result:[String : AnyObject]?, _ error: CMCError?) -> Void) -> URLSessionDataTask? {
        
        let versionParams = NSMutableDictionary(dictionary: params).buildVersionParams()
        log.info("versionParams: \(versionParams)")
        
        return CMCRequestManager.sharedClient().post("order/addReceiptPrintTime", parameters: versionParams, progress: nil, success: { (sessionTask, responseData) in
            
            let responseDic = try? JSONSerialization.jsonObject(with: responseData as! Data,
                                                                options: .allowFragments)
            log.info("getIndexPoint responseDic: \(responseDic)")
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
