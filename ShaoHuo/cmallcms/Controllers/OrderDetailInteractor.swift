//
//  OrderDetailInteractor.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
//import Viperit

final class OrderDetailInteractor: Interactor {
    
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
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OrderDetailInteractor {
    var presenter: OrderDetailPresenter {
        return _presenter as! OrderDetailPresenter
    }
}
