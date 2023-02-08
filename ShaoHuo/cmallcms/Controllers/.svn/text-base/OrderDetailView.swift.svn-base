//
//  OrderDetailView.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import MJRefresh
import JSQWebViewController

//MARK: - Public Interface Protocol
protocol OrderDetailViewInterface {
    func finishedLoadOrderInfo() -> Void
    func getOrderDetail()
    func showOrderShippingList()
}

//MARK: OrderDetail View
final class OrderDetailView: UserInterface {
    
    //var dataSource: [CMCStaticSectionEntity] = []
    
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.view.backgroundColor = CMCColor.loginViewBackgroundColor
        self.view.backgroundColor = CMCColor.loginViewBackgroundColor
        self.configTableView()
    
    }
    
    
    func rightBarButtonPressed() {
        
        if GPrintHelp.shared.isConnecting {
            self.presenter.addReciptPrintCount()
            GPrintHelp.shared.printReceipt(orderDetail: self.presenter.orderEntity!.order!)
            
            //self.presenter.orderEntity?.order?.print_count += 1
            
            self.presenter.orderEntity!.order!.print_count! += 1
            
            self.showPrintButton()
        }
        else {
            let alert = UIAlertController(title: "提示",
                                          message: "打印机连接失败，请打开手机蓝牙，然后在 \"我的->打印机设置\" 中连接打印设备",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (alertController) in
                
            }))
            
            self.navigationController?.presentVC(alert)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //if self.presenter.orderEntity == nil {
            //self.tableView?.mj_header.beginRefreshing()
        self.getOrderDetail()
        //}
    }
    
    func configTableView() {
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.grouped)
        self.view.addSubview(tableView!)
        
        self.tableView?.register(UINib(nibName: "TitleLabelTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: TitleLabelTableViewCell.className)
        
        self.tableView?.register(UINib(nibName: "SKUItemTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: SKUItemTableViewCell.className)
        
        self.tableView?.register(UINib(nibName: "OrderListInfoTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: OrderListInfoTableViewCell.className)
        
        self.tableView?.register(OrderActionTableViewCell.classForCoder(),
                                 forCellReuseIdentifier: OrderActionTableViewCell.className)
        //OrderReceiveTableViewCell
        self.tableView?.register(UINib(nibName: "OrderReceiveTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: OrderReceiveTableViewCell.className)
        
        //OrderDetailInfoTableViewCell
        self.tableView?.register(OrderDetailInfoTableViewCell.classForCoder(),
                                 forCellReuseIdentifier: OrderDetailInfoTableViewCell.className)
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 100
        
        self.tableView?.separatorInset = UIEdgeInsets.zero
        self.tableView?.layoutMargins = UIEdgeInsets.zero
        
        let refreshHeader = MJRefreshNormalHeader {
            [weak self] in
            //self?.getNewOrderList(status: self?.segmentedControl.selectedSegmentIndex ?? 0)
            self?.getOrderDetail()
        }
        self.tableView?.mj_header = refreshHeader
        
        //dataSource.tableView = self.tableView
    }
    
    func getOrderDetail() {
        self.presenter.getOrderDetailFromServer()
    }
    
    func getNumberOfRowInSection(section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 1
        }
        if section == 2 {
            if let itemCount = self.presenter.orderEntity?.order?.sub_list?.count {
                if self.presenter.needShowActionButton() {
                    return itemCount + 3
                }
                return itemCount + 2
            }
            return 3
        }
        if section == 3 {
            return 1
        }
        return 0
    }
    
    deinit {
        log.warning("OrderDetailView")
    }
    
    /// 处理订单操作
    ///
    /// - Parameters:
    ///   - indexPath:
    ///   - title:
    func prcessOrderAction(indexPath: IndexPath, title: String) -> Void {
        
        let support_status = self.presenter.orderEntity?.order?.support_status ?? 0
        
        if title == "发货" {
            if support_status > 0 {
                if support_status == SUPPORT_STATUS_REFUND_CLOSED {
                    log.info("获取物流列表")
                    self.presenter.getOrderShippingList()
                }
                else {
                    self.showErrorHUDView(errorString: "退款中订单不可发货，请联系买家")
                }
            }
            else {
                log.info("获取物流列表")
                self.presenter.getOrderShippingList()
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
                                            self?.presenter.cancelOrder()
            }))
            
            self.presentVC(alert)
        }
        
        if title == "联系买家" {
            let phoneNumber = self.presenter.orderEntity?.order?.mobile ?? ""
            self.showPhonePickView(phoneNumber)
        }
    }
    
    /// 显示打印小票按钮
    func showPrintButton() {
        
        if self.presenter.orderEntity?.order?.status == ORDER_STATUS_DELIVERED
            || self.presenter.orderEntity?.order?.status == ORDER_STATUS_SUCCESS {
            
            let print_count = self.presenter.orderEntity?.order?.print_count ?? 0
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "打印(\(print_count))",
                style: UIBarButtonItemStyle.plain,
                target: self,
                action: #selector(OrderDetailView.rightBarButtonPressed))
        }
    }
}

//MARK: - Public interface
extension OrderDetailView: OrderDetailViewInterface {
    
    func finishedLoadOrderInfo() {
        self.tableView?.mj_header.endRefreshing()
        self.tableView?.reloadData()
        
        self.showPrintButton()
    }
    
    func showOrderShippingList() {
    
        let shippingList = self.presenter.shippingList
        
        if shippingList.count <= 0 {
            return
        }
        
        let deliverOrderController = DeliveryOrderViewController(nibName: "DeliveryOrderViewController", bundle: nil)
        deliverOrderController.title = "选择配送方式"
        deliverOrderController.hidesBottomBarWhenPushed = true
        deliverOrderController.shippingList = shippingList
        deliverOrderController.orderId = self.presenter.orderId
        self.navigationController?.pushViewController(deliverOrderController, animated: true)
        
//        deliverOrderController.selectedShippingTypeCallback = {
//            [weak self] (shippingType, expressName, expressId) in
//            log.info("shippingType: \(shippingType) expressName:\(expressName) expressId:\(expressId)")
//            //shipping_type: Int, express_name: String, shipping_id: String
//            self?.presenter.deliveryOrder(shipping_type: shippingType,
//                                          express_name: expressName,
//                                          shipping_id: expressId)
//        }

    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OrderDetailView {
    var presenter: OrderDetailPresenter {
        return _presenter as! OrderDetailPresenter
    }
    var displayData: OrderDetailDisplayData {
        return _displayData as! OrderDetailDisplayData
    }
    
    
    func configOrderActionTableViewCel(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tmpCell = tableView.dequeueReusableCell(withIdentifier: OrderActionTableViewCell.className,
                                                    for: indexPath) as! OrderActionTableViewCell
        
        tmpCell.indexPath = indexPath
        
        let status = self.presenter.orderEntity?.order?.status ?? 0
        let support_status = self.presenter.orderEntity?.order?.support_status ?? 0
        
        tmpCell.setOrderStatus(status: status, support_status: support_status,page_type: 1)
        
        tmpCell.buttonActionCallback = {
            [weak self] (indexPath,title) in
            self?.prcessOrderAction(indexPath: indexPath!, title: title!)
        }
        return tmpCell
    }
    
    func configOrderListInfoTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tmpCell = tableView.dequeueReusableCell(withIdentifier: OrderListInfoTableViewCell.className,
                                                    for: indexPath) as! OrderListInfoTableViewCell

        
        let shipping_fee = self.presenter.orderEntity?.order?.shipping_fee ?? 0
        let bonus_amount = self.presenter.orderEntity?.order?.bonus_amount ?? 0
        let amount = self.presenter.orderEntity?.order?.amout ?? 0
        
        tmpCell.createTimeTitleLabel.text = "运费："
        tmpCell.createTimeLabel.text = String(format: "￥%.2f", shipping_fee*0.01)
        tmpCell.createTimeLabel.textAlignment = NSTextAlignment.right
        
        tmpCell.orderSNTitleLabel.text = "优惠："
        tmpCell.orderSNLabel.text = String(format: "￥%.2f", bonus_amount*0.01)
        tmpCell.orderSNLabel.textAlignment = NSTextAlignment.right
        
        tmpCell.receiveAddressTitleLabel.text = "合计："
        tmpCell.receiveAddressLabel.text = String(format: "￥%.2f", (amount+shipping_fee-bonus_amount)*0.01)
        tmpCell.receiveAddressLabel.textAlignment = NSTextAlignment.right
        tmpCell.receiveAddressLabel.textColor = CMCColor.hlightedButtonBackgroundColor
        
        return tmpCell
    }
    
    func configSKUItemTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let skuItemEntity = self.presenter.orderEntity!.order!.sub_list![indexPath.row - 1]
        let tmpCell = tableView.dequeueReusableCell(withIdentifier: SKUItemTableViewCell.className,
                                                    for: indexPath) as! SKUItemTableViewCell
        
        tmpCell.skuItemEntity = skuItemEntity
        
        return tmpCell
    }
    
    func configTitleLabelTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let tmpCell = tableView.dequeueReusableCell(withIdentifier: TitleLabelTableViewCell.className,
                                                    for: indexPath) as! TitleLabelTableViewCell
        
        if indexPath.section == 0 {
            let status_text = self.presenter.orderEntity?.order?.status_text ?? ""
            
            tmpCell.rightLabel.textAlignment = NSTextAlignment.left
            tmpCell.configLabtlText(leftLabelAttributeString: NSAttributedString(string: "订单状态： "),
                                    rightLabelAttributeString: NSAttributedString(string: status_text))
        }
        if indexPath.section == 2 {
            let createName = self.presenter.orderEntity?.order?.username ?? ""
            tmpCell.configLabtlText(leftLabelAttributeString: NSAttributedString(string: createName),
                                    rightLabelAttributeString: NSAttributedString(string: " "))
        }
        
        return tmpCell
    }
    
    func configOrderReceiveTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tmpCell = tableView.dequeueReusableCell(withIdentifier: OrderReceiveTableViewCell.className,
                                                    for: indexPath) as! OrderReceiveTableViewCell
        
        let province_name = self.presenter.orderEntity?.order?.province_name ?? ""
        let city_name = self.presenter.orderEntity?.order?.city_name ?? ""
        let district_name = self.presenter.orderEntity?.order?.district_name ?? ""
        let address = self.presenter.orderEntity?.order?.address ?? ""
        
        tmpCell.nameLabel.text = self.presenter.orderEntity?.order?.consignee ?? ""
        tmpCell.phoneNumberLabel.text = self.presenter.orderEntity?.order?.mobile ?? ""
        tmpCell.addressLabel.text = "\(province_name)\(city_name)\(district_name)\(address)"
        return tmpCell
    }
    
    func configOrderDetailInfoTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tmpCell = tableView.dequeueReusableCell(withIdentifier: OrderDetailInfoTableViewCell.className, for: indexPath) as! OrderDetailInfoTableViewCell
        
        
        tmpCell.setShowTitles(titles: self.presenter.getOrderInfoTitleByStatus(),
                              values: self.presenter.getOrderInfoArrtibuteList())
        
        return tmpCell
    }
}


extension OrderDetailView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.presenter.orderEntity == nil {
            return 0
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getNumberOfRowInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if indexPath.section == 0 {
            cell = self.configTitleLabelTableViewCell(tableView, cellForRowAt: indexPath)
        }
        else if indexPath.section == 1 {
//            let tmpCell = tableView.dequeueReusableCell(withIdentifier: OrderReceiveTableViewCell.className,
//                                                        for: indexPath) as! OrderReceiveTableViewCell
//            
//            let province_name = self.presenter.orderEntity?.order?.province_name ?? ""
//            let city_name = self.presenter.orderEntity?.order?.city_name ?? ""
//            let district_name = self.presenter.orderEntity?.order?.district_name ?? ""
//            let address = self.presenter.orderEntity?.order?.address ?? ""
//
//            tmpCell.nameLabel.text = self.presenter.orderEntity?.order?.consignee ?? ""
//            tmpCell.phoneNumberLabel.text = self.presenter.orderEntity?.order?.mobile ?? ""
//            tmpCell.addressLabel.text = "\(province_name)\(city_name)\(district_name)\(address)"
//            
//            cell = tmpCell
            cell = self.configOrderReceiveTableViewCell(tableView, cellForRowAt: indexPath)
        }
        else if indexPath.section == 2 {
            
            if self.presenter.needShowActionButton() {
                if indexPath.row == 0 {
                    cell = self.configTitleLabelTableViewCell(tableView, cellForRowAt: indexPath)
                }
                else if indexPath.row == self.getNumberOfRowInSection(section: indexPath.section) - 1 {
                    cell = self.configOrderActionTableViewCel(tableView, cellForRowAt: indexPath)
                    
                }
                else if indexPath.row == self.getNumberOfRowInSection(section: indexPath.section) - 2 {
                    cell = self.configOrderListInfoTableViewCell(tableView, cellForRowAt: indexPath)
                }
                else {
                    cell = self.configSKUItemTableViewCell(tableView, cellForRowAt: indexPath)
                }
            }
            else {
                if indexPath.row == 0 {
                    cell = self.configTitleLabelTableViewCell(tableView, cellForRowAt: indexPath)
                }
                else if indexPath.row == self.getNumberOfRowInSection(section: indexPath.section) - 1 {
                    cell = self.configOrderListInfoTableViewCell(tableView, cellForRowAt: indexPath)
                    
                }
                else {
                    cell = self.configSKUItemTableViewCell(tableView, cellForRowAt: indexPath)
                }
            }
        }
        else if indexPath.section == 3 {
            cell = self.configOrderDetailInfoTableViewCell(tableView, cellForRowAt: indexPath)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 38
        }
        if indexPath.section == 1 {
            return 100
        }
        if indexPath.section == 2 {
            if self.presenter.needShowActionButton() {
                if indexPath.row == 0 {
                    return 38
                }
                else if indexPath.row == self.getNumberOfRowInSection(section: indexPath.section) - 1 {
                    return 49
                }
                else if indexPath.row == self.getNumberOfRowInSection(section: indexPath.section) - 2 {
                    return 101
                }
            }
            else {
                if indexPath.row == 0 {
                    return 38
                }
                else if indexPath.row == self.getNumberOfRowInSection(section: indexPath.section) - 1 {
                    return 101
                }
            }
            return 113
        }
        if indexPath.section == 3 {
            return tableView.fd_heightForCell(withIdentifier: OrderDetailInfoTableViewCell.className, configuration: { (cell) in
                let tmpCell = cell as! OrderDetailInfoTableViewCell
                
                tmpCell.setShowTitles(titles: self.presenter.getOrderInfoTitleByStatus(),
                                      values: self.presenter.getOrderInfoArrtibuteList())
            })
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hview = UIView()
        return hview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
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
        
        if indexPath.section == 2 {
            
            var needPushWebView = false
            if self.presenter.needShowActionButton() {
                needPushWebView = indexPath.row != self.getNumberOfRowInSection(section: indexPath.section) - 1
                    && indexPath.row != self.getNumberOfRowInSection(section: indexPath.section) - 2
                    && indexPath.row != 0
            }
            else {
                needPushWebView = indexPath.row != self.getNumberOfRowInSection(section: indexPath.section) - 1
                    && indexPath.row != 0
            }
            if needPushWebView {
                let sub_list = self.presenter.orderEntity?.order?.sub_list
                let sub_item = sub_list![indexPath.row-1]
                let goods_id = sub_item.goods_id ?? ""
                let webController: WebViewController  = WebViewController(url: URL(string: "\(CMallHTML5HostUrlString)index/details?goods_id=\(goods_id)")!)
                webController.displaysWebViewTitle = true
                self.navigationController?.show(webController, sender: nil)
            }
        }
    }
}
