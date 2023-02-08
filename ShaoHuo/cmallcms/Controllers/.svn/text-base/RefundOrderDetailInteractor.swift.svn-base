//
//  RefundOrderDetailInteractor.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/25.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
//import Viperit

final class RefundOrderDetailInteractor: Interactor {
    
    func getOrderDetailFromServer(orderId: String) -> URLSessionDataTask? {
        
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "order_id": orderId
        ]
        
        return OrderListModel.shared.orderRefundDetail(params, complete: {
            [weak self] (dicData, error) in
            self?.presenter.responseOrderDetail(result: dicData, error: error)
        })
    }
    
    /// 同意/拒绝退款
    ///
    /// - Parameters:
    ///   - order_id: 订单编号
    ///   - rl_id: 退款单编号
    ///   - status: 同意:2，拒绝：3
    ///   - refuse_reason: 拒绝原因
    func orderRefundDisposeFromServer(order_id: String, rl_id: String, status: String, refuse_reason: String) -> URLSessionDataTask? {
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "order_id": order_id,
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "rl_id": rl_id,
            "status": status,
            "refuse_reason": refuse_reason
        ]
        
        return OrderListModel.shared.orderRefundDispose(params, complete: { (result, error) in
            self.presenter.responseRefunDispose(status: status, error: error)
        })
        
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension RefundOrderDetailInteractor {
    var presenter: RefundOrderDetailPresenter {
        return _presenter as! RefundOrderDetailPresenter
    }
}
