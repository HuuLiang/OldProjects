//
//  OrderSearchView.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/27.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import JSQWebViewController
import DZNEmptyDataSet
import EZSwiftExtensions

//MARK: - Public Interface Protocol
protocol OrderSearchViewInterface {
    var tableView: UITableView? {get set}
    
    func noMoreData() -> Void
    func finishedLoad() -> Void
    
    func needReloadOrderList() -> Void
    /// 显示支持的物流列表
    ///
    /// - Returns:
    func showOrderShippingList() -> Void
}

//MARK: OrderSearch View
final class OrderSearchView: UserInterface {
    
    var searchTextField: UITextField?
    
    var tableView: UITableView?
    
    var currentSlectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CMCColor.loginViewBackgroundColor
        self.configNavigationSearchBar()
        self.configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func cancelBarButtonItemPressed() {
        //self.dismiss(animated: true, completion: nil)
        self.popVC()
    }
    
    func configNavigationSearchBar() {
        /*
        self.navigationController?.navigationBar.lt_setBackgroundGradientColor(colors: CMCColor.navbarGradientColor,
                                                                               startPoint: CGPoint(x: 0, y: 0),
                                                                               endPoint: CGPoint(x: 1, y: 0),
                                                                               locations: [0, 0.65, 1.0])
        */
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let statusBarView = UIView()
        statusBarView.frame = CGRect(x: 0, y: 0, w: self.view.w, h: 20)
        statusBarView.cmc_addGradientLayer(colors: CMCColor.navbarGradientColor,
                                           startPoint: CGPoint(x: 0, y: 0),
                                           endPoint: CGPoint(x: 1, y: 0),
                                           locations: [0, 0.65, 1.0])
        self.view.addSubview(statusBarView)
        
        let searchBarView = UIView(frame: CGRect(x: 0, y: 20, w: self.view.w, h: 44))
        self.view.addSubview(searchBarView)
        searchBarView.backgroundColor = UIColor.white
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(hexString: "C9C9C9")
        searchBarView.addSubview(lineView)
        lineView.frame = CGRect(x: 0, y: 43, w: self.view.w, h: 1)
        
        let searchBarGarybgView = UIView(frame: CGRect(x: 14, y: 6, w: self.view.w - 64, h: 32))
        searchBarView.addSubview(searchBarGarybgView)
        searchBarGarybgView.backgroundColor = UIColor(hexString: "F2F2F2")
        searchBarGarybgView.layer.cornerRadius = 5
        searchBarGarybgView.layer.masksToBounds = true
        
        let iconImageView = UIImageView(image: UIImage(named: "icon_search"))
        iconImageView.frame = CGRect(x: 10, y: 9, w: 14, h: 14)
        searchBarGarybgView.addSubview(iconImageView)
        
        searchTextField = UITextField(frame: CGRect(x: 34, y: 6, w: searchBarGarybgView.w - 44, h: 20))
        searchTextField?.borderStyle = UITextBorderStyle.none
        searchTextField?.placeholder = "请输入订单编号检索订单"
        searchTextField?.font = UIFont.systemFont(ofSize: 14)
        searchBarGarybgView.addSubview(searchTextField!)
        searchTextField?.addTarget(self,
                                   action: #selector(OrderSearchView.textFieldValueChanged(textField:)),
                                   for: UIControlEvents.editingChanged)
        
        let cancelButton = UIButton(type: UIButtonType.custom)
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.frame = CGRect(x: self.view.w - 50, y: 5, w: 50, h: 34)
        cancelButton.addTarget(self, action: #selector(OrderSearchView.cancelBarButtonItemPressed),
                               for: UIControlEvents.touchUpInside)
        cancelButton.setTitleColor(CMCColor.hlightedButtonBackgroundColor, for: UIControlState.normal)
        searchBarView.addSubview(cancelButton)
        
    }
    
    func textFieldValueChanged(textField: UITextField) -> Void {
        log.info("textFiedl: \(textField.text ?? "")")
        if let searchKeyword = textField.text {
            self.getNewOrderList(status: 0, search: searchKeyword.trimmed())
        }
    }
    
    func configTableView() -> Void {
        
        //et tableViewFrame = CGRect(x: 0, y: 0, w: self.view.w, h: self.view.h )
        self.tableView = UITableView(frame: CGRect.zero,
                                     style: UITableViewStyle.grouped)
        self.view.addSubview(self.tableView!)
        
        self.tableView!.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.top.equalTo()(64)
            let _ = make?.bottom.equalTo()(0)
        }
        
        self.tableView?.register(UINib(nibName: "TitleLabelTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: TitleLabelTableViewCell.className)
        
        self.tableView?.register(UINib(nibName: "SKUItemTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: SKUItemTableViewCell.className)
        
        self.tableView?.register(UINib(nibName: "OrderListInfoTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: OrderListInfoTableViewCell.className)
        
        self.tableView?.register(OrderActionTableViewCell.classForCoder(),
                                 forCellReuseIdentifier: OrderActionTableViewCell.className)
        
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 100
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.tableView?.separatorInset = UIEdgeInsets.zero
        self.tableView?.layoutMargins = UIEdgeInsets.zero
        
        self.tableView?.emptyDataSetSource = self
        self.tableView?.emptyDataSetDelegate = self
        self.tableView?.tableFooterView = UIView()
    }
    
    func getNewOrderList(status: Int, search: String) -> Void {
        self.presenter.refreshNewData(status: status, searchText: search)
    }
    /// 根据SECTION 获取总行数
    ///
    /// - Parameter section:
    /// - Returns:
    func getTotalRowBySection(section: Int) -> Int {
        let itemEntity = self.presenter.orderList[section]
        return itemEntity.sub_list.count + 3
    }
    
    /// 处理订单操作
    ///
    /// - Parameters:
    ///   - indexPath:
    ///   - title:
    func prcessOrderAction(indexPath: IndexPath, title: String) -> Void {
        log.info("title: \(title) indexPath: \(indexPath)")
        let orderListItem = self.presenter.orderList[indexPath.section]
        
        currentSlectedIndex = indexPath
        
        if title == "发货" {
            if orderListItem.support_status! > 0 {
                if orderListItem.support_status! == SUPPORT_STATUS_REFUND_CLOSED {
                    log.info("获取物流列表")
                    self.presenter.getOrderShippingList(orderId: orderListItem.order_id ?? "")
                }
                else {
                    self.showErrorHUDView(errorString: "退款中订单不可发货，请联系买家")
                }
            }
            else {
                log.info("获取物流列表")
                self.presenter.getOrderShippingList(orderId: orderListItem.order_id ?? "")
            }
        }
        if title == "取消订单" {
            let alert = UIAlertController(title: "确认取消订单？",
                                          message: nil,
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "取消",
                                          style: UIAlertActionStyle.cancel,
                                          handler: { (alertAction) in
                                            
                                            
                                            
            }))
            
            alert.addAction(UIAlertAction(title: "确认",
                                          style: UIAlertActionStyle.default,
                                          handler: {
                                            [weak self] (alertAction) in
                                            self?.presenter.cancelOrder(orderId: orderListItem.order_id ?? "")
            }))
            
            self.presentVC(alert)
        }
        if title == "订单详情" {
            self.showOrderDetailController(orderId: orderListItem.order_id ?? "")
        }
        if title == "退款详情" {
            self.showRefundOrderDetailController(orderId: orderListItem.order_id ?? "")
        }
    }
    /// 显示订单详情
    ///
    /// - Parameter orderId: 订单编号
    func showOrderDetailController(orderId: String) {
        
        let orderDetailModel = Module.build("OrderDetail")
        //orderDetailModel.view.hidesBottomBarWhenPushed = true
        orderDetailModel.router.show(from: self.navigationController!,
                                     embedInNavController: false,
                                     setupData: orderId)
        //self.navigationController?.pushViewController(orderDetailModel.view, animated: true)
    }
    
    func showRefundOrderDetailController(orderId: String) {
        let orderDetailModel = Module.build("RefundOrderDetail")
        //orderDetailModel.view.hidesBottomBarWhenPushed = true
        orderDetailModel.router.show(from: self.navigationController!,
                                     embedInNavController: false,
                                     setupData: orderId)
        //self.navigationController?.pushViewController(orderDetailModel.view, animated: true)
    }

}

//MARK: - Public interface
extension OrderSearchView: OrderSearchViewInterface {
    func noMoreData() {
        self.tableView?.reloadData()
    }
    
    func finishedLoad() {
        self.tableView?.reloadData()
    }
    
    func needReloadOrderList() {
        //self.tableView?.mj_header.beginRefreshing()
        //self.getNewOrderList(status: self.segmentedControl.selectedSegmentIndex)
        
        self.getNewOrderList(status: 0, search: self.searchTextField?.text ?? "")
    }
    
    func showOrderShippingList() {
        
        let orderListItem = self.presenter.orderList[currentSlectedIndex!.section]
        
        let shippingList = self.presenter.shippingList
        
        let deliverOrderController = DeliveryOrderViewController(nibName: "DeliveryOrderViewController", bundle: nil)
        deliverOrderController.title = "选择配送方式"
        deliverOrderController.hidesBottomBarWhenPushed = true
        deliverOrderController.shippingList = shippingList
        self.navigationController?.pushViewController(deliverOrderController, animated: true)
        
        deliverOrderController.selectedShippingTypeCallback = {
            [weak self] (shippingType, expressName, expressId) in
            log.info("shippingType: \(shippingType) expressName:\(expressName) expressId:\(expressId)")
            
            self?.presenter.deliveryOrder(orderId: orderListItem.order_id ?? "",
                                          shipping_type: shippingType,
                                          express_name: expressName,
                                          shipping_id: expressId)
        }
    }

}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OrderSearchView {
    var presenter: OrderSearchPresenter {
        return _presenter as! OrderSearchPresenter
    }
    var displayData: OrderSearchDisplayData {
        return _displayData as! OrderSearchDisplayData
    }
}

extension OrderSearchView : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.orderList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let itemEntity = self.presenter.orderList[section]
        return self.getTotalRowBySection(section: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        let orderListItem = self.presenter.orderList[indexPath.section]
        
        if indexPath.row == 0 {
            let tmpCell = tableView.dequeueReusableCell(withIdentifier: TitleLabelTableViewCell.className,
                                                        for: indexPath) as! TitleLabelTableViewCell
            
            var status_text = orderListItem.status_text ?? ""
            if orderListItem.support_status! > 0 {
                switch orderListItem.support_status! {
                case SUPPORT_STATUS_REFUND_ING:
                    status_text = "发起退款申请"
                case SUPPORT_STATUS_REFUND_REFUSED:
                    status_text = "驳回退款"
                case SUPPORT_STATUS_REFUND_AGAIN:
                    status_text = "买家二次申请退款"
                case SUPPORT_STATUS_REFUND_CLOSED:
                    status_text = "买家撤销退款"
                case SUPPORT_STATUS_REFUND_SUCCESS:
                    status_text = "退款完成"
                default:
                    status_text = "退款申请中"
                }
            }
            
            tmpCell.configLabtlText(leftLabelAttributeString: NSAttributedString(string: orderListItem.username ?? ""),
                                    rightLabelAttributeString: NSAttributedString(string: status_text))
            
            cell = tmpCell
        }
        else if indexPath.row == self.getTotalRowBySection(section: indexPath.section) - 1 {
            let tmpCell = tableView.dequeueReusableCell(withIdentifier: OrderActionTableViewCell.className,
                                                        for: indexPath) as! OrderActionTableViewCell
            tmpCell.indexPath = indexPath
            
            tmpCell.buttonActionCallback = {
                [weak self] (indexPath,title) in
                self?.prcessOrderAction(indexPath: indexPath!, title: title!)
            }
            
            tmpCell.setOrderStatus(status: orderListItem.status ?? 0,
                                   support_status: orderListItem.support_status ?? 0)
            
            cell = tmpCell
        }
        else if indexPath.row == self.getTotalRowBySection(section: indexPath.section) - 2 {
            let tmpCell = tableView.dequeueReusableCell(withIdentifier: OrderListInfoTableViewCell.className,
                                                        for: indexPath) as! OrderListInfoTableViewCell
            
            tmpCell.createTimeLabel.text = orderListItem.createtime ?? ""
            tmpCell.orderSNLabel.text = orderListItem.order_sn ?? ""
            
            let province_name = orderListItem.province_name ?? ""
            let city_name = orderListItem.city_name ?? ""
            let district_name = orderListItem.district_name ?? ""
            let address = orderListItem.address ?? ""
            
            tmpCell.receiveAddressLabel.text = "\(province_name)\(city_name)\(district_name)\(address)"
            
            cell = tmpCell
        }
        else {
            let skuItemEntity = orderListItem.sub_list[indexPath.row - 1]
            
            let tmpCell = tableView.dequeueReusableCell(withIdentifier: SKUItemTableViewCell.className,
                                                        for: indexPath) as! SKUItemTableViewCell
            
            tmpCell.skuItemEntity = skuItemEntity
            
            cell = tmpCell
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 38
        }
        else if indexPath.row == self.getTotalRowBySection(section: indexPath.section) - 1 {
            return 49
        }
        else if indexPath.row == self.getTotalRowBySection(section: indexPath.section) - 2 {
            return 101
        }
        return 113
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hview = UIView()
        return hview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 14
        }
        return 7
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let hview = UIView()
        return hview
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let orderListItem = self.presenter.orderList[indexPath.section]
        
        if indexPath.row != self.getTotalRowBySection(section: indexPath.section) - 1
            && indexPath.row != self.getTotalRowBySection(section: indexPath.section) - 2
            && indexPath.row != 0 {
            
            let sub_item = orderListItem.sub_list[indexPath.row-1]
            let goods_id = sub_item.goods_id ?? ""
            let webController: WebViewController  = WebViewController(url: URL(string: "\(CMallHTML5HostUrlString)index/details?goods_id=\(goods_id)")!)
            webController.displaysWebViewTitle = true
            //webController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webController, animated: true)
            //self.navigationController?.show(webController, sender: nil)
        }
        else {
            self.showOrderDetailController(orderId: orderListItem.order_id ?? "")
        }
    }
}

extension OrderSearchView : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "icon_no_order_result")
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        if let searchText = self.searchTextField?.text, searchText.length > 0 {
            return true
        }
        return false
    }
}
