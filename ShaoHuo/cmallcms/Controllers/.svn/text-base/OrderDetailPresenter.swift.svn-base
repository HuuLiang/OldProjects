//
//  OrderDetailPresenter.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import MBProgressHUD
import ObjectMapper
import EZSwiftExtensions

final class OrderDetailPresenter: Presenter {
    
    var orderId: String!
    
    var sessionDataTask: URLSessionDataTask?
    
    var hud: MBProgressHUD?
    
    var orderEntity: OrderDetailEntity?
    
    // 支持的物流列表信息 1：捎货物流，2：其它物流，3：自提，4：送货上门 value: 1, name:捎货物流
    var shippingList: [[String: AnyObject]] = []
    
    override func setupView(data: Any) {
        let tmpOrderId = data as! String
        orderId = tmpOrderId
        
        log.info("orderId:\(orderId)")
        log.info("orderId:\(data)")
    }
    
    func getOrderDetailFromServer() -> Void {
        
        _view.showHUDLoadView()
        
        sessionDataTask = self.interactor.getOrderDetailFromServer(orderId: orderId)
    }
    
    func cancelOrder() -> Void {
        _view.showHUDLoadView()
        sessionDataTask = self.interactor.cancelOrder(orderId: orderId)
    }
    
    func getOrderShippingList() -> Void {
        let _ = _view.showHUDLoadView()
        self.interactor.getOrderShippingList(orderId: orderId)
    }

    /// 发货
    ///
    /// - Parameters:
    ///   - shipping_type: 发货类型
    ///   - express_name: 快递公司
    ///   - shipping_id: 快递编号
    func deliveryOrder(shipping_type: Int, express_name: String, shipping_id: String) -> Void {
        _view.showHUDLoadView()
        sessionDataTask = self.interactor.deliveryOrder(orderId: orderId,
                                                        shipping_type: shipping_type,
                                                        express_name: express_name,
                                                        shipping_id: shipping_id)
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
                _view.navigationItem.title = (orderEntity?.order?.status_text ?? "") + "订单"
            }
            view.finishedLoadOrderInfo()
        }
    }
    
    /// 取消订单
    ///
    /// - Parameter error: 返回结果
    func responseOrderCancel(error: CMCError?) -> Void {
        if let tmpError = error {
            switch tmpError {
            case .jsonSerializedFailed, .verifyTextFieldError(_):
                _view.showErrorHUDView(errorString: "加载数据失败")
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
            _view.showSuccessHUDView(messageString: "取消订单成功")
            ez.runThisAfterDelay(seconds: 1.5, after: {
                [weak self] in
                self?.view.getOrderDetail()
            })
        }
    }
    
    func responseOrderDelivery(error: CMCError?) -> Void {
        
        if let tmpError = error {
            switch tmpError {
            case .jsonSerializedFailed, .verifyTextFieldError(_):
                _view.showErrorHUDView(errorString: "加载数据失败")
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
            _view.showSuccessHUDView(messageString: "订单发货成功")
            ez.runThisAfterDelay(seconds: 1.5, after: {
                [weak self] in
                self?.view.getOrderDetail()
                
            })
        }
    }
    
    func responseOrderShippingList(result: [String: AnyObject]?, error: CMCError?) -> Void {
        
        if let tmpError = error {
            switch tmpError {
            case .jsonSerializedFailed, .verifyTextFieldError(_):
                _view.showErrorHUDView(errorString: "加载数据失败")
            case .responseError(let code, let message):
                _view.hidHUDView()
                if _view.checkErrorCode(code: code) {
                    
                }
                else {
                    _view.showErrorHUDView(errorString: message, code: code)
                }
            }
        }
        else {
            _view.hidHUDView()
            if result != nil {
                self.shippingList = result!["list"] as! [[String: AnyObject]]
            }
            view.showOrderShippingList()
        }
    }

    
    deinit {
        sessionDataTask?.cancel()
    }
    
    /// 获取显示title 根据 status
    ///
    /// - Returns:
    func getOrderInfoTitleByStatus() -> [String] {
        
        switch self.orderEntity!.order!.status! {
        case ORDER_STATUS_UNPAY:
            return ["订单编号","订单创建时间"]
//        case ORDER_STATUS_PAYED:
//            return ["订单编号","订单创建时间","付款时间","付款方式","发货方式"]
        case ORDER_STATUS_DELIVERED, ORDER_STATUS_PAYED:

            var menuArray: [String] = ["订单编号","订单创建时间","付款时间","付款方式","发货方式"]
            if self.orderEntity!.order!.shipping_type == ORDER_SHIPPING_TYPE_SELF {
                menuArray.append("自提地点")//提货时间
                menuArray.append("提货时间")
            }
            if self.orderEntity!.order!.remark!.length > 0 {
                menuArray.append("备注")
            }
            return menuArray
        case ORDER_STATUS_SUCCESS:
            return ["订单编号","订单创建时间"]
        case ORDER_STATUS_CLOSED:
            return ["订单编号","订单创建时间"]
        case ORDER_STATUS_REFUND:
            return ["订单编号","订单创建时间"]
        default:
            return []
        }
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
                else if shipping_type == ORDER_SHIPPING_TYPE_OTHER {
                    attributeStrings.append("其它物流")
                }
                else {
                    attributeStrings.append(" ")
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
        }
        return attributeStrings
    }
    
    func needShowActionButton() -> Bool {
        if let status = self.orderEntity?.order?.status, status == ORDER_STATUS_DELIVERED || status == ORDER_STATUS_SUCCESS || status == ORDER_STATUS_CLOSED || status == ORDER_STATUS_REFUND {
            return false
        }
        return true
    }
    
    /// 增加打印小票次数
    func addReciptPrintCount() {
        self.interactor.addReceiptPrintCount(orderId: self.orderId)
    }
    
    func responseReceiptPrintCount(error: CMCError?) -> Void {
        if error != nil {
            log.error(error?.localizedDescription ?? "")
        }
        else {
            log.info("增加打印小票次数成功")
        }
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OrderDetailPresenter {
    var view: OrderDetailViewInterface {
        return _view as! OrderDetailViewInterface
    }
    var interactor: OrderDetailInteractor {
        return _interactor as! OrderDetailInteractor
    }
    var router: OrderDetailRouter {
        return _router as! OrderDetailRouter
    }
}
