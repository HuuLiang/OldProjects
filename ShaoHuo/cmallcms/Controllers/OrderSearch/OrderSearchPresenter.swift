//
//  OrderSearchPresenter.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/27.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import MBProgressHUD
import ObjectMapper
import AFNetworking
import JDStatusBarNotification
import EZSwiftExtensions

final class OrderSearchPresenter: Presenter {
    
    lazy var pageListParam: PageListModel = {
        return PageListModel(from: "0", last: "0", size: 10, lastPage: false)
    }()
    //订单状态，默认全部（1,2,3,4,5,6分别为等待买家付款，买家已付款，商家已发货，交易完成，已关闭，已退款）
    var lastOrderStatus: Int = 1
    
    //var hud: MBProgressHUD?
    
    var orderList: [OrderListEntity] = []
    
    let manager = AFNetworkReachabilityManager(forDomain: "www.apple.com")
    
    var sessionDataTask: URLSessionDataTask?
    
    // 支持的物流列表信息 1：捎货物流，2：其它物流，3：自提，4：送货上门 value: 1, name:捎货物流
    var shippingList: [[String: AnyObject]] = []
    
    func refreshNewData(status: Int, searchText: String) -> Void {
        pageListParam.from = "0"
        pageListParam.last = "0"
        self.orderList.removeAll()
        view.tableView?.reloadData()
        
        sessionDataTask?.cancel()
        //let _ = _view.showHUDLoadView()
        if searchText.length > 0 {
            sessionDataTask = interactor.getOrderListFromServer(pageListParam: pageListParam,
                                                                status: status,
                                                                searchText: searchText)
        }
        
    }
    
//    func getOrderList(status: Int) -> Void {
//        sessionDataTask?.cancel()
//        sessionDataTask = interactor.getOrderListFromServer(pageListParam: pageListParam, status: status)
//    }
    
    func cancelOrder(orderId: String) -> Void {
        let _ = _view.showHUDLoadView()
        sessionDataTask = self.interactor.cancelOrder(orderId: orderId)
    }
    
    func getOrderShippingList(orderId: String) -> Void {
        let _ = _view.showHUDLoadView()
        self.interactor.getOrderShippingList(orderId: orderId)
    }
    
    func deliveryOrder(orderId: String, shipping_type: Int, express_name: String, shipping_id: String) {
        
        _view.showHUDLoadView()
        let _ = self.interactor.deliveryOrder(orderId: orderId,
                                              shipping_type: shipping_type,
                                              express_name: express_name,
                                              shipping_id: shipping_id)
    }
    
    func responseOrderList(result: [String: AnyObject]?, error: CMCError?) -> Void {
        
        if let tmpError = error {
            
            switch tmpError {
            case .jsonSerializedFailed, .verifyTextFieldError(_):
                //_view.showErrorHUDView(errorString: "加载数据失败")
                _view.hidHUDView()
            case .responseError(let code, let message):
                
                if _view.checkErrorCode(code: code) {
                    _view.hidHUDView()
                }
                else {
                    _view.hidHUDView()
                }
                log.error("code: \(code), message:\(message)")
            }
            
            view.finishedLoad()
        }
        else {
            
            _view.hidHUDView()
            
            if result == nil {
                view.finishedLoad()
            }
            else {
                let listJSONArray = result?["list"] as! [[String: AnyObject]]
                let mapper = Mapper<OrderListEntity>()
                let tmpOrderList: [OrderListEntity] = mapper.mapArray(JSONArray: listJSONArray)!
                
                if tmpOrderList.count <= 0 {
                    view.noMoreData()
                }
                else {
                    self.orderList.append(contentsOf: tmpOrderList)
                    
                    let lastItem = self.orderList.last
                    
                    self.pageListParam.from = lastItem?.order_id ?? ""
                    self.pageListParam.last = ""
                    
                    view.finishedLoad()
                }
                log.info("responseOrderList result :\(result)")
            }
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
                self?.view.needReloadOrderList()
            })
        }
    }
    
    /// 响应发货操作
    ///
    /// - Parameter error:
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
            
            _view.showSuccessHUDView(messageString: "发货成功")
            ez.runThisAfterDelay(seconds: 1.5, after: {
                [weak self] in
                self?.view.needReloadOrderList()
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
            self.shippingList = result!["list"] as! [[String: AnyObject]]
            view.showOrderShippingList()
        }
    }
    
    deinit {
        sessionDataTask?.cancel()
    }

}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OrderSearchPresenter {
    var view: OrderSearchViewInterface {
        return _view as! OrderSearchViewInterface
    }
    var interactor: OrderSearchInteractor {
        return _interactor as! OrderSearchInteractor
    }
    var router: OrderSearchRouter {
        return _router as! OrderSearchRouter
    }
}
