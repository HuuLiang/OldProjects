//
//  OrderSearchInteractor.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/27.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation

//import Viperit

final class OrderSearchInteractor: Interactor {
    
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
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "status": "\(status)",
            "search_text": searchText,
            "size": "\(pageListParam.size)",
            "from": pageListParam.from,
            "is_support": status == 6 ? "1" : "0",
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

}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OrderSearchInteractor {
    var presenter: OrderSearchPresenter {
        return _presenter as! OrderSearchPresenter
    }
}
