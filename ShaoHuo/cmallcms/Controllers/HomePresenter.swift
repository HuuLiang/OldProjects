//
//  HomePresenter.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import MBProgressHUD
import ObjectMapper
import AFNetworking
import JDStatusBarNotification
import EZSwiftExtensions
//import Viperit

final class HomePresenter: Presenter {
    
    lazy var pageListParam: PageListModel = {
        return PageListModel(from: "0", last: "0", size: 10, lastPage: false)
    }()
    //订单状态，默认全部（1,2,3,4,5,6分别为等待买家付款，买家已付款，商家已发货，交易完成，已关闭，已退款）
    var lastOrderStatus: Int = 1
    
    //var hud: MBProgressHUD?
    
    var orderList: [OrderListEntity] = []
    
    let manager = AFNetworkReachabilityManager(forDomain: "www.ishaohuo.cn")
    
    var sessionDataTask: URLSessionDataTask?
    
    // 支持的物流列表信息 1：捎货物流，2：其它物流，3：自提，4：送货上门 value: 1, name:捎货物流
    var shippingList: [[String: AnyObject]] = []
    
    /// 当前正在响应操作的 订单 ID
    var actionOrderId: String?
    
    override func viewHasLoaded() {
        
        manager.setReachabilityStatusChange {
            [weak self] (status: AFNetworkReachabilityStatus) in
            switch status {
            case .unknown:
                log.warning("NetworkReachabilityStatus.Unknown")
                self?.view.showNoNetWorkErrorView()
                break
            case .notReachable:
                log.warning("NetworkReachabilityStatus.NotReachable")
                self?.view.showNoNetWorkErrorView()
                break
            case .reachableViaWWAN:
                log.info("3G")
                self?.view.hideNoNetWorkErrorView()
            case .reachableViaWiFi:
                log.info("wifi")
                self?.view.hideNoNetWorkErrorView()
            }
        }
        
        manager.startMonitoring()
        
        // 提交设备信息到服务器
        self.interactor.postUserDeviceInfoToServer()
        PushNotificationHelp.showBadgeValue()
        
        // 设置别名
        if let alias = UserTicketModel.sharedInstance.alias {
            UMessage.addAlias(alias, type: "ishaohuo", response: { (responseObject, error) in
                log.info("responseObject: \(responseObject)")
            })
        }
        
        if UserTicketModel.sharedInstance.isLogin && UserTicketModel.sharedInstance.login_type == .phone {
            self.getShopList()
        }
    }
    
    override func viewHasAppeared() {
        PushNotificationHelp.showBadgeValue()
        
        self.getOrderDetailFromServer()
    }
    
    func refreshNewData(status: Int) -> Void {
        
        pageListParam.from = "0"
        pageListParam.last = "0"
        self.orderList.removeAll()
        view.tableView?.reloadData()
        
        sessionDataTask?.cancel()
        let _ = _view.showHUDLoadView()
        
        sessionDataTask = interactor.getOrderListFromServer(pageListParam: pageListParam, status: status)
    }
    
    func getOrderList(status: Int) -> Void {
        sessionDataTask?.cancel()
        sessionDataTask = interactor.getOrderListFromServer(pageListParam: pageListParam, status: status)
    }
    
    func cancelOrder(orderId: String) -> Void {
        let _ = _view.showHUDLoadView()
        sessionDataTask = self.interactor.cancelOrder(orderId: orderId)
        actionOrderId = orderId
    }
    
    func getOrderShippingList(orderId: String) -> Void {
        let _ = _view.showHUDLoadView()
        self.interactor.getOrderShippingList(orderId: orderId)
        actionOrderId = orderId
    }
    
    func deliveryOrder(orderId: String, shipping_type: Int, express_name: String, shipping_id: String) {
        
        //let _ = _view.showHUDLoadView()
        let _ = self.interactor.deliveryOrder(orderId: orderId,
                                              shipping_type: shipping_type,
                                              express_name: express_name,
                                              shipping_id: shipping_id)
        
        actionOrderId = orderId
    }
    
    func getShopList() {
        self.interactor.getShopListFromServer()
    }
    
    /// 批量发货
    func batchShippingOrder() {
        
        let orderIds = self.orderList.map { (item) -> String in
            return item.order_id ?? ""
        }
        
        if orderIds.count > 0 {
            _view.showHUDLoadView()
            let _ = self.interactor.batchShippingOrderFromServer(orderIds: orderIds)
        }
    }
    
    func addReciptPrintCount(orderId: String) {
        self.interactor.addReceiptPrintCount(orderId: orderId)
    }
    
    /// 响应批量发货
    ///
    /// - Parameters:
    ///   - result: 结
    ///   - error: 错误
    func responseBatchShippingOrder(result: [String: AnyObject]?, error: CMCError?) -> Void {
        
        if let tmpError = error {
            
            switch tmpError {
            case .jsonSerializedFailed, .verifyTextFieldError(_):
                _view.showErrorHUDView(errorString: "加载数据失败")
            case .responseError(let code, let message):
                if _view.checkErrorCode(code: code) {
                    _view.hidHUDView()
                }
                else {
                    
                    if code == 522 {
                        self.view.needReloadOrderList()
                        
                        let alertController = UIAlertController(title: "提示",
                                                                message: message, preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (alert) in
                            
                        }))
                        _view.presentVC(alertController)
                        
                        
                        if let success_ids = result?["success_ids"] as? [String], success_ids.count > 0  {
                            self.printReceipt(orderIds: success_ids)
                        }
                        
                    }
                    else {
                        _view.showErrorHUDView(errorString: message, code: code)
                    }
                }
            }
        }
        else {
            
            if let success_ids = result?["success_ids"] as? [String], success_ids.count > 0  {
                self.printReceipt(orderIds: success_ids)
            }
            
            self.view.needReloadOrderList()
            _view.showSuccessHUDView(messageString: "批理发货成功")
        }
    }
    
    /// 打小票
    ///
    /// - Parameter orderIds:
    func printReceipt(orderIds: [String]) {
        
        for item in self.orderList {
            if orderIds.contains(item.order_id ?? "") {
                GPrintHelp.shared.printReceipt(orderDetail: item)
                //self.addReciptPrintCount(orderId: item.order_id ?? "")
            }
        }
        let printOrderIds = orderIds.joined(separator: ",")
        self.addReciptPrintCount(orderId: printOrderIds)
    }
    
    func responseOrderList(result: [String: AnyObject]?, error: CMCError?) -> Void {
        
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
            }
        }
    }
    
    /// 获取当前正在操作的订单实体
    ///
    /// - Returns:
    func getActionOrderItem() -> OrderListEntity? {
        
        if let tmpActionOrderId = self.actionOrderId {
            
            let itemList = self.orderList.filter({ (item) -> Bool in
                return item.order_id == tmpActionOrderId
            })
            
            return itemList.first
        }
        return nil
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
            self.getOrderDetailFromServer()
            ez.runThisAfterDelay(seconds: 1.0, after: {
                //[weak self] in
                //self?.view.needReloadOrderList()
                //self?.view.finishedLoad()
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
            self.getOrderDetailFromServer()
            ez.runThisAfterDelay(seconds: 1.0, after: {
                //[weak self] in
                //self?.view.needReloadOrderList()
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
                if let rsultArray = result?["list"] as? [[String: AnyObject]] {
                    self.shippingList = rsultArray
                }
                else {
                    self.shippingList = []
                }
            }
            view.showOrderShippingList()
        }
    }
    
    func responseShopList(error: CMCError?) -> Void {
        if error != nil {
            log.error(error?.localizedDescription ?? "")
        }
        else {
            log.info("获取Shop列表成功")
        }
    }
    
    func responseReceiptPrintCount(error: CMCError?) -> Void {
        if error != nil {
            log.error(error?.localizedDescription ?? "")
        }
        else {
            log.info("增加打印小票次数成功")
        }
    }
    
    /// 获取订单详情
    func getOrderDetailFromServer() {
        
        if let tmpOrderId = self.actionOrderId {
            let _ = self.interactor.getOrderDetailFromServer(orderId: tmpOrderId)
        }
        
    }
    
    func responseOrderDetail(result: [String: AnyObject]?, error: CMCError?) -> Void {
        
        if let tmpError = error {
            log.error(tmpError.localizedDescription )
        }
        else {
            _view.hidHUDView()
            if result != nil {
                let mapper = Mapper<OrderDetailEntity>()
                let orderEntity = mapper.map(JSON: result!)
                
                if let tempItem = self.getActionOrderItem() {
                    tempItem.status = orderEntity?.order?.status
                    tempItem.support_status = orderEntity?.order?.support_status
                    tempItem.status_text = orderEntity?.order?.status_text
                }
            }
            self.actionOrderId = nil
            view.finishedLoad()
        }
    }
    
    deinit {
        sessionDataTask?.cancel()
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension HomePresenter {
    var view: HomeViewInterface {
        return _view as! HomeViewInterface
    }
    var interactor: HomeInteractor {
        return _interactor as! HomeInteractor
    }
    var router: HomeRouter {
        return _router as! HomeRouter
    }
}


