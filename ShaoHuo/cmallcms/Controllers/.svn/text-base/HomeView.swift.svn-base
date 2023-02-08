//
//  HomeView.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import MJRefresh
import JSQWebViewController
import DZNEmptyDataSet
import EZSwiftExtensions

//MARK: - Public Interface Protocol
protocol HomeViewInterface {
    
    var tableView: UITableView? {get set}
    
    func noMoreData() -> Void
    func finishedLoad() -> Void
    
    func needReloadOrderList() -> Void
    /// 显示支持的物流列表
    ///
    /// - Returns:
    func showOrderShippingList() -> Void
    
    func showNoNetWorkErrorView() -> Void
    func hideNoNetWorkErrorView() -> Void
}

//MARK: Home View
final class HomeView: UserInterface {
    
    var segmentedControl: HMSegmentedControl!
    
    var tableView: UITableView?
    
    var currentSlectedIndex: IndexPath?
    
    var noNetworkView: UIView?
    
    var errorViewIsShow: Bool = false
    
    // 批量发货按钮
    var batchShippingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSegmentio()
        self.configTableView()
        self.configBatchShipping()
        
        self.getNewOrderList(status: self.segmentedControl.selectedSegmentIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configNavBarTitleView()
    }
    
    func configBatchShipping() {
        batchShippingButton = UIButton(type: UIButtonType.custom)
        batchShippingButton.setImage(UIImage(named: "icon_batch_shipping"),
                                     for: UIControlState.normal)
        batchShippingButton.addTarget(self,
                                      action: #selector(HomeView.batchButtonPressed),
                                      for: UIControlEvents.touchUpInside)
        view.addSubview(batchShippingButton)
        
        batchShippingButton.mas_makeConstraints { (make) in
            let _ = make?.bottom.equalTo()(-60)
            let _ = make?.right.equalTo()(-14)
            let _ = make?.size.equalTo()(CGSize(width: 92, height: 92))
        }
        
        batchShippingButton.isHidden = true
    }
    
    func configNavBarTitleView() {
        
        self.navigationItem.titleView = nil
        
        let shopNameButton = UIButton(type: UIButtonType.custom)
        shopNameButton.setTitle(UserTicketModel.sharedInstance.shop_name ?? "", for: UIControlState.normal)
        shopNameButton.setImage(UIImage(named: "icon_down_arrow"), for: UIControlState.normal)
        shopNameButton.addTarget(self,
                                 action: #selector(HomeView.shopNameBtnPressed),
                                 for: UIControlEvents.touchUpInside)
        
        shopNameButton.frame = CGRect(x: 0, y: 0, w: 200, h: 30)
        
        let labelSize = shopNameButton.titleLabel!.sizeThatFits(CGSize(width: 180, height: 30))
        
        shopNameButton.imageEdgeInsets = UIEdgeInsets(top: 2,
                                                      left: labelSize.width,
                                                      bottom: 0,
                                                      right: -labelSize.width)
            
        shopNameButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 20)
        
        
        self.navigationItem.titleView = shopNameButton
        
    }
    
    /// 批量发货 事件
    func batchButtonPressed() -> Void {
        log.info("batchButtonPressed")
        
        func sendShipping() {
            let alert = UIAlertController(title: "提示",
                                          message: "批量发货的商品仅允许到店自提，是否确认操作？",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: { (alertController) in
                
                self.presenter.batchShippingOrder()
                
            }))
            
            self.navigationController?.presentVC(alert)
        }
        
        if GPrintHelp.shared.isConnecting == false {
            
            let alert = UIAlertController(title: "提示",
                                          message: "打印机连接失败，请打开手机蓝牙，然后在 \"我的->打印机设置\" 中连接打印设备",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "继续发货", style: UIAlertActionStyle.default, handler: { (alertController) in
                sendShipping()
            }))
            
            self.navigationController?.presentVC(alert)
        }
        else {
            sendShipping()
        }
    }
    
    func shopNameBtnPressed() -> Void {
        
        if UserTicketModel.sharedInstance.shop_list.count <= 0 {
            return
        }
        
        let shopListView = ShopListViewController()
        shopListView.title = "选择店铺管理"
        shopListView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(shopListView, animated: true)
        
        shopListView.callBack = {
           [weak self] (needRload) in
            self?.getNewOrderList(status: self!.segmentedControl.selectedSegmentIndex)
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
            let _ = make?.top.equalTo()(self.segmentedControl.mas_bottom)
            let _ = make?.bottom.equalTo()(-49)
        }
       
        self.tableView?.register(UINib(nibName: "TitleLabelTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: TitleLabelTableViewCell.className)
        
        self.tableView?.register(UINib(nibName: "SKUItemTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: SKUItemTableViewCell.className)
        
        self.tableView?.register(UINib(nibName: "OrderListInfoTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: OrderListInfoTableViewCell.className)
        
        self.tableView?.register(OrderActionTableViewCell.classForCoder(),
                                 forCellReuseIdentifier: OrderActionTableViewCell.className)
        
        
        log.info("TitleLabelTableViewCell: \(TitleLabelTableViewCell.className)")
        log.info("SKUItemTableViewCell.className: \(SKUItemTableViewCell.className)")
        log.info("OrderListInfoTableViewCell: \(OrderListInfoTableViewCell.className)")
        log.info("OrderActionTableViewCell: \(OrderActionTableViewCell.className)")
        
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 75
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.tableView?.separatorInset = UIEdgeInsets.zero
        self.tableView?.layoutMargins = UIEdgeInsets.zero
        
        self.tableView?.emptyDataSetSource = self
        self.tableView?.emptyDataSetDelegate = self
        self.tableView?.tableFooterView = UIView()
        
        let refreshHeader = MJRefreshNormalHeader { 
            [weak self] in
            self?.getNewOrderList(status: self?.segmentedControl.selectedSegmentIndex ?? 0)
            
        }
        refreshHeader?.lastUpdatedTimeLabel.isHidden = true
        self.tableView?.mj_header = refreshHeader
    
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            [weak self] in
            self?.getOrderList(status: self?.segmentedControl.selectedSegmentIndex ?? 0)
        })
    }
    
    //MARK: - Private Methods
    func configSegmentio() {
        
        let placeholdView = UIView()
        self.view.addSubview(placeholdView)
        placeholdView.backgroundColor = UIColor.clear
        
        placeholdView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.height.equalTo()(19)
            let _ = make?.top.equalTo()(0)
        }
        
        self.noNetworkView = UIView()
        self.noNetworkView?.backgroundColor = UIColor(hexString: "feeeee")
        self.view.addSubview(self.noNetworkView!)
        self.noNetworkView!.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.height.equalTo()(35)
            let _ = make?.top.equalTo()(29)
        }
        
        let erroImageView = UIImageView(image: UIImage(named: "icon_no_network"))
        self.noNetworkView!.addSubview(erroImageView)
        erroImageView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(14)
            let _ = make?.size.equalTo()(CGSize(width: 19, height: 19))
            let _ = make?.centerY.equalTo()(0)
        }
        
        let erroTipMsgLabel = UILabel()
        erroTipMsgLabel.text = "网络异常，请检查网络！"
        erroTipMsgLabel.font = UIFont.systemFont(ofSize: 15)
        erroTipMsgLabel.textColor = UIColor(hexString: "333333")
        self.noNetworkView!.addSubview(erroTipMsgLabel)
        erroTipMsgLabel.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(erroImageView.mas_right)?.setOffset(14)
            let _ = make?.right.equalTo()(-14)
            let _ = make?.height.equalTo()(20)
            let _ = make?.top.equalTo()(7)
        }
        let sepLineView = UIView()
        sepLineView.backgroundColor = CMCColor.normalLineColor
        self.noNetworkView!.addSubview(sepLineView)
        sepLineView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.height.equalTo()(0)
            let _ = make?.bottom.equalTo()(0)
        }
        
        
        segmentedControl = HMSegmentedControl(sectionTitles: ["全部","待付款","待发货","待收货","已完成","已关闭","退款订单"])
        segmentedControl.autoresizingMask = UIViewAutoresizing.flexibleWidth
        segmentedControl.frame = CGRect(x: 0, y: 64, w: self.view.w, h: 35)
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segmentedControl.isVerticalDividerEnabled = false
        
        
        segmentedControl.titleTextAttributes = [
            NSForegroundColorAttributeName : CMCColor.normalButtonBackgroundColor,
            NSFontAttributeName : UIFont.systemFont(ofSize: 15)
        ]
        
        segmentedControl.selectedTitleTextAttributes = [
            NSForegroundColorAttributeName : CMCColor.hlightedButtonBackgroundColor,
            NSFontAttributeName : UIFont.systemFont(ofSize: 15)
        ]
        
        segmentedControl.selectionIndicatorColor = CMCColor.hlightedButtonBackgroundColor
        segmentedControl.selectionIndicatorHeight = 2
        
        segmentedControl.borderType = HMSegmentedControlBorderType.bottom
        segmentedControl.borderColor = CMCColor.segmentedBorderColor
        segmentedControl.borderWidth = 1
        
        self.view.addSubview(segmentedControl)
        
        segmentedControl.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.height.equalTo()(35)
            let _ = make?.right.equalTo()(0)
            let _ = make?.top.equalTo()(self.noNetworkView!.mas_bottom)
        }
        
        segmentedControl.indexChangeBlock = {
            [weak self] index in
            self?.getNewOrderList(status: index)
            self?.batchShippingButton.isHidden = index != 2
        }
        
        // 搜索
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, w: 30, h: 30))
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchButton)
        searchButton.setImage(UIImage(named:"icon_search_white"), for: UIControlState.normal)
        searchButton.addTarget(self,
                               action: #selector(HomeView.searchBarButtonPressed(sender:)),
                               for: UIControlEvents.touchUpInside)
        let searchBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        self.navigationItem.lt_setLeftBarButtonItem(leftBarButtonItem: searchBarButtonItem)
    }
    // 订单搜索
    func searchBarButtonPressed(sender: UIButton) {
//        let searchModel = Module.build("OrderSearch")
//        searchModel.router.showDetail(from: self.navigationController!,
//                                      embedInNavController: true, setupData: nil)
//        
        
        let searchModel = Module.build("OrderSearch")
        searchModel.view.hidesBottomBarWhenPushed = true
        searchModel.router.show(from: self.navigationController!,
                                     embedInNavController: false,
                                     setupData: nil)

    }
    
    //订单状态，默认全部（1,2,3,4,5,6分别为等待买家付款，买家已付款，商家已发货，交易完成，已关闭，已退款）
    func getOrderList(status: Int) -> Void {
        self.presenter.getOrderList(status: status)
    }
    
    func getNewOrderList(status: Int) -> Void {
        self.presenter.refreshNewData(status: status)
    }
    
    func getNewOrderList() -> Void {
        if self.segmentedControl != nil {
            let status = self.segmentedControl.selectedSegmentIndex
            self.presenter.refreshNewData(status: status)
        }
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
        
        self.presenter.actionOrderId = orderId
        
        let orderDetailModel = Module.build("OrderDetail")
        orderDetailModel.view.hidesBottomBarWhenPushed = true
        orderDetailModel.router.show(from: self.navigationController!,
                                     embedInNavController: false,
                                     setupData: orderId)
        //self.navigationController?.pushViewController(orderDetailModel.view, animated: true)
    }
    
    func showRefundOrderDetailController(orderId: String) {
        
        self.presenter.actionOrderId = orderId
        
        let orderDetailModel = Module.build("RefundOrderDetail")
        orderDetailModel.view.hidesBottomBarWhenPushed = true
        orderDetailModel.router.show(from: self.navigationController!,
                                     embedInNavController: false,
                                     setupData: orderId)
    }
    /*
    func selectedOrderShippingType(index: Int) -> Void {
        
        let orderListItem = self.presenter.orderList[currentSlectedIndex!.section]
        
        let dicItem: [String: AnyObject] = self.presenter.shippingList[index]
        
        let title: String = dicItem["name"] as! String
        var shippingType: Int? =  dicItem["value"] as? Int
        if shippingType == nil {
            shippingType = (dicItem["value"] as! String).toInt() ?? 0
        }
        
        if shippingType == ORDER_SHIPPING_TYPE_SH {
            self.presenter.deliveryOrder(orderId: orderListItem.order_id ?? "",
                                         shipping_type: shippingType ?? 0,
                                         express_name: title,
                                         shipping_id: "")
        }
    }*/
}

//MARK: - Public interface
extension HomeView: HomeViewInterface {
    
    func noMoreData() {
        self.tableView?.mj_header.endRefreshing()
        self.tableView?.mj_footer.endRefreshingWithNoMoreData()
        //self.tableView?.reloadData()
    }
    
    func finishedLoad() {
        self.tableView?.mj_header.endRefreshing()
        self.tableView?.mj_footer.endRefreshing()
        
        self.tableView?.reloadData()
    }
    
    func needReloadOrderList() {
        //self.tableView?.mj_header.beginRefreshing()
        self.getNewOrderList(status: self.segmentedControl.selectedSegmentIndex)
        
        PushNotificationHelp.showBadgeValue()
    }
    
    func showOrderShippingList() {
        
        let orderListItem = self.presenter.orderList[currentSlectedIndex!.section]
        let shippingList = self.presenter.shippingList
        
        if shippingList.count <= 0 {
            return
        }
        
        let deliverOrderController = DeliveryOrderViewController(nibName: "DeliveryOrderViewController", bundle: nil)
        deliverOrderController.title = "选择配送方式"
        deliverOrderController.hidesBottomBarWhenPushed = true
        deliverOrderController.shippingList = shippingList
        deliverOrderController.orderId = orderListItem.order_id ?? ""
        self.navigationController?.pushViewController(deliverOrderController, animated: true)
        
        self.presenter.actionOrderId = orderListItem.order_id
        
    }
    
    func showNoNetWorkErrorView() {
        
        errorViewIsShow = true
        
        self.noNetworkView!.mas_updateConstraints { (make) in
           let _ = make?.top.equalTo()(64)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func hideNoNetWorkErrorView() {
        
        if errorViewIsShow == false {
            return
        }
        
        self.noNetworkView!.mas_updateConstraints { (make) in
            let _ = make?.top.equalTo()(29)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        if self.presenter.orderList.count <= 0 {
            ez.runThisAfterDelay(seconds: 0.3, after: { 
                //self.tableView?.mj_header.beginRefreshing()
                self.presenter.refreshNewData(status: self.segmentedControl.selectedSegmentIndex)
            })
        }

        errorViewIsShow = false
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension HomeView {
    var presenter: HomePresenter {
        return _presenter as! HomePresenter
    }
    var displayData: HomeDisplayData {
        return _displayData as! HomeDisplayData
    }
}


extension HomeView : UITableViewDataSource , UITableViewDelegate {
    
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
            tmpCell.fd_enforceFrameLayout = true
            
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
            tmpCell.fd_enforceFrameLayout = true
            
            cell = tmpCell
        }
        
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //let orderListItem = self.presenter.orderList[indexPath.section]
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
            webController.hidesBottomBarWhenPushed = true
            //webController.progressBar.tintColor = CMCColor.hlightedButtonBackgroundColor
            
            self.navigationController?.show(webController, sender: nil)
        }
        else if indexPath.row == 0 {
            //mobile
            self.showPhonePickView(orderListItem.mobile ?? "")
        }
        else {
            
            self.showOrderDetailController(orderId: orderListItem.order_id ?? "")
        }
    }
}

extension HomeView : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "icon_no_order")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributeString = NSMutableAttributedString(string: "暂时没有订单")
        
        attributeString.addAttributes([
            NSFontAttributeName: UIFont.systemFont(ofSize: 15),
            NSForegroundColorAttributeName : UIColor(hexString: "9c9c9c")!
            ], range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

