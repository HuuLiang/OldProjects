//
//  HomeInteractor.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import EZSwiftExtensions
import ObjectMapper
//import Viperit

final class HomeInteractor: Interactor {
    
    /// 订单列表
    ///
    /// - Parameters:
    ///   - pageListParam:
    ///   - status: status == 6 退款订单
    ///   - searchText:
    /// - Returns:
    func getOrderListFromServer(pageListParam: PageListModel,status: Int, searchText: String = "") -> URLSessionDataTask? {
        
        let params = [
                "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
                "token": UserTicketModel.sharedInstance.token ?? "",
                "status": "\(status)",
                "search_text": searchText,
                "size": "\(pageListParam.size)",
                "from": pageListParam.from,
                "is_support": status == 6 ? "1" : "0",
                "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
                "last": pageListParam.last
                      ]
        
        return OrderListModel.shared.orderList(params) { (result, error) in
            self.presenter.responseOrderList(result: result, error: error)
        }
    }
    
    func cancelOrder(orderId: String) -> URLSessionDataTask? {
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "order_id": orderId
        ]
        
        return OrderListModel.shared.cancelOrder(params) { (result, error) in
            self.presenter.responseOrderCancel(error: error)
        }
    }
    
    func deliveryOrder(orderId: String, shipping_type: Int, express_name: String, shipping_id: String) -> URLSessionDataTask? {
        
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "order_id": orderId,
            "shipping_type": "\(shipping_type)",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "express_name": express_name,
            "shipping_id": shipping_id
        ]
        
        return OrderListModel.shared.orderDelivery(params) { (result, error) in
            self.presenter.responseOrderDelivery(error: error)
        }
    }
    
    /// 提交设备信息到服务器
    func postUserDeviceInfoToServer() {
        let params = [
            "token": UserTicketModel.sharedInstance.token ?? "",
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "app_version": ez.appVersionAndBuild ?? "",
            "device_name": UIDevice.deviceName(),
            "device_version": UIDevice.CURRENT_VERSION,
            "device_mode": UIDevice.deviceModel(),
            "mobile_type": "1"
        ]
        
        UserLoginModel.shared.postUserDeviceInfo(params) { (error) in
            
            if let tmpError = error {
                switch tmpError {
                case .jsonSerializedFailed, .verifyTextFieldError(_):
                    log.error("jsonSerializedFailed")
                case .responseError(let code,let message):
                    log.error("code: \(code) message: \(message)")
                }
            }
            else {
                log.info("UserLoginModel.shared.postUserDeviceInfo Done .....")
            }
        }
    }
    
    func getOrderShippingList(orderId: String) -> Void {
        
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "order_id": orderId,
        ]
        
        OrderListModel.shared.orderShippingList(params: params) { (result, error) in
            self.presenter.responseOrderShippingList(result: result, error: error)
        }
    }
    
    func getShopListFromServer() -> Void {
        let params = [
            "phone": UserTicketModel.sharedInstance.mobile_phone ?? "",
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "size": "20",
            "from": "",
            "last": ""
        ]
        
        let _ = UserLoginModel.shared.userShopLists(params) { (result, error) in
            if let tmpError = error {
                log.error("\(tmpError.localizedDescription)")
                
                self.presenter.responseShopList(error: error)
            }
            else {
                
                let listJSONArray = result?["list"] as! [[String: AnyObject]]
                let mapper = Mapper<ShopItemEntity>()
                let tmpOrderList: [ShopItemEntity] = mapper.mapArray(JSONArray: listJSONArray)!
                
                UserTicketModel.sharedInstance.shop_list.removeAll()
                
                UserTicketModel.sharedInstance.shop_list.append(contentsOf: tmpOrderList)
                
                self.presenter.responseShopList(error: nil)
            }
        }
    }
    
    /// 批量发货
    func batchShippingOrderFromServer(orderIds: [String], shippingType: Int = ORDER_SHIPPING_TYPE_SELF) -> URLSessionDataTask? {
       
        let orderIdsString = orderIds.joined(separator: ",")
        
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "order_ids": orderIdsString,
            "shipping_type": "\(shippingType)"
        ]
        
        return OrderListModel.shared.orderBatchDelivery(params) { (result, error) in
            self.presenter.responseBatchShippingOrder(result: result, error: error)
        }
        
    }
    
    /// 增加打印次数
    ///
    /// - Parameter orderId: 订单号
    func addReceiptPrintCount(orderId: String) {
        
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "order_ids": orderId
        ]
        
        let _ = OrderListModel.shared.orderAddReceiptPrintCount(params) { (result, error) in
            self.presenter.responseReceiptPrintCount(error: error)
        }
    }
    
    func getOrderDetailFromServer(orderId: String) -> URLSessionDataTask? {
        
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "order_id": orderId
        ]
        
        return OrderListModel.shared.orderDetail(params) {
            [weak self] (dicData, error) in
            self?.presenter.responseOrderDetail(result: dicData, error: error)
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension HomeInteractor {
    var presenter: HomePresenter {
        return _presenter as! HomePresenter
    }
}
