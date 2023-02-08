//
//  RefundOrderDetailPresenter.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/25.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import MBProgressHUD
import ObjectMapper
import EZSwiftExtensions

final class RefundOrderDetailPresenter: Presenter {
    
    var orderId: String!
    
    var sessionDataTask: URLSessionDataTask?
    
    var hud: MBProgressHUD?
    
    var orderEntity: OrderDetailEntity?
    
    override func setupView(data: Any) {
        let tmpOrderId = data as! String
        orderId = tmpOrderId
        
        log.info("orderId:\(orderId)")
        log.info("orderId:\(data)")
    }
    
    func getOrderDetailFromServer() -> Void {
        
        let _ = _view.showHUDLoadView()
        
        sessionDataTask = self.interactor.getOrderDetailFromServer(orderId: orderId)
    }
    
    /// 退款处理
    ///
    /// - Parameters:
    ///   - status: 同意:2，拒绝：3
    ///   - status_reason: 拒绝原因
    func refunDispose(status: String, status_reason: String) -> Void {
        let _ = _view.showHUDLoadView()
        
        let rl_id = self.orderEntity?.refund?.rl_id ?? ""
        
        sessionDataTask = self.interactor.orderRefundDisposeFromServer(order_id: orderId,
                                                                       rl_id: rl_id,
                                                                       status: status,
                                                                       refuse_reason: status_reason)
    }
    
    func responseOrderDetail(result: [String: AnyObject]?, error: CMCError?) -> Void {
        
        if let tmpError = error {
            switch tmpError {
            case .jsonSerializedFailed, .verifyTextFieldError(_):
                _view.showErrorHUDView(errorString: "加载订单信息失败")
            case .responseError(let code, let message):
                
                if _view.checkErrorCode(code: code) {
                    _view.hidHUDView()
                }
                else {
                    _view.showErrorHUDView(errorString: message, code: code)
                }
            }
        }
        else {
            _view.hidHUDView()
            if result != nil {
                let mapper = Mapper<OrderDetailEntity>()
                orderEntity = mapper.map(JSON: result!)
            }
            view.finishedLoadOrderInfo()
        }
    }
    
    /// 退款单处理结果响应
    ///
    /// - Parameters:
    ///   - status: 同意:2，拒绝：3
    ///   - error: 错误码
    func responseRefunDispose(status: String, error: CMCError?) -> Void {
        if let tmpError = error {
            switch tmpError {
            case .jsonSerializedFailed, .verifyTextFieldError(_):
                _view.showErrorHUDView(errorString: "加载信息失败")
            case .responseError(let code, let message):
                
                if _view.checkErrorCode(code: code) {
                    _view.hidHUDView()
                }
                else {
                    _view.showErrorHUDView(errorString: message, code: code)
                }
            }
        }
        else {
            _view.showSuccessHUDView(messageString: "操作成功")
            ez.runThisAfterDelay(seconds: 1.5, after: { 
                self.view.getOrderDetail()
            })
        }
    }
    
    
    func getOrderInfoTitleByStatus() -> [String] {
        
        var menuArray: [String] = ["订单编号","订单创建时间","付款时间","付款方式","收货信息"]
        if self.orderEntity!.order!.shipping_type == ORDER_SHIPPING_TYPE_SELF {
            menuArray.append("自提地点")//提货时间
            menuArray.append("提货时间")
        }
        //menuArray.append("订单来源")
        //if self.orderEntity!.order!.remark!.length > 0 {
        menuArray.append("备注")
        //}
        return menuArray
        
    }
    
    func getOrderInfoArrtibuteList() -> [String] {
        var attributeStrings: [String] = []
        
        for item in getOrderInfoTitleByStatus() {
            if item == "订单编号" {
                attributeStrings.append(self.orderEntity?.order?.order_sn ?? "")
            }
            if item == "订单创建时间" {
                attributeStrings.append(self.orderEntity!.order!.createtime ?? "")
            }
            if item == "付款时间" {
                attributeStrings.append(self.orderEntity!.order!.pay_time ?? "")
            }
            if item == "付款方式" {
                attributeStrings.append(self.orderEntity!.order!.payment_text ?? "")
            }
            if item == "发货方式" {
                let shipping_type = self.orderEntity!.order!.shipping_type!
                if shipping_type ==  ORDER_SHIPPING_TYPE_SH {
                    attributeStrings.append("捎货物流")
                }
                else if shipping_type == ORDER_SHIPPING_TYPE_SELF {
                    attributeStrings.append("自提")
                }
                else {
                    //express_name
                    attributeStrings.append(self.orderEntity!.order!.express_name ?? "")
                }
            }
            if item == "备注" {
                attributeStrings.append(self.orderEntity!.order!.remark ?? "")
            }
            if item == "自提地点" {
                let self_shipping_address = "\(self.orderEntity?.order?.self_shipping_name ?? "")(\(self.orderEntity!.order!.self_shipping_address ?? ""))"
                attributeStrings.append(self_shipping_address)
            }
            if item == "提货时间" {
                attributeStrings.append(self.orderEntity!.order!.self_shipping_time ?? "")
            }
            if item == "收货信息" {
                
                let province_name = self.orderEntity?.order?.province_name ?? ""
                let city_name = self.orderEntity?.order?.city_name ?? ""
                let district_name = self.orderEntity?.order?.district_name ?? ""
                let address = self.orderEntity?.order?.address ?? ""
            
                attributeStrings.append("\(province_name)\(city_name)\(district_name)\(address) \(self.orderEntity?.order?.consignee ?? "") \(self.orderEntity?.order?.mobile ?? "")")
            }
        }
        return attributeStrings
    }
    
    /// 是否显示退款按钮
    ///
    /// - Returns: true 显示， false 不显示
    func needShowRefundButton() -> Bool {
        
        if let status = self.orderEntity?.refund?.status,
            status == REFUND_STATUS_ING
            || status == REFUND_STATUS_REFUSED {
            
            if let support_status = self.orderEntity?.order?.support_status {
                if support_status == SUPPORT_STATUS_REFUND_SUCCESS
                    || support_status == SUPPORT_STATUS_REFUND_CLOSED {
                    return false
                }
            }
            
            return true
        }
        return false
    }
    
    //SUPPORT_STATUS_REFUND_REFUSED
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension RefundOrderDetailPresenter {
    var view: RefundOrderDetailViewInterface {
        return _view as! RefundOrderDetailViewInterface
    }
    var interactor: RefundOrderDetailInteractor {
        return _interactor as! RefundOrderDetailInteractor
    }
    var router: RefundOrderDetailRouter {
        return _router as! RefundOrderDetailRouter
    }
}
