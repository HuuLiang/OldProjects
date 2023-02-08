//
//  RefundOrderDetailView.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/25.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import MJRefresh
import JSQWebViewController
import DateToolsSwift

//MARK: - Public Interface Protocol
protocol RefundOrderDetailViewInterface {
    
    func finishedLoadOrderInfo()
    func getOrderDetail()
}

//MARK: RefundOrderDetail View
final class RefundOrderDetailView: UserInterface {
    
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "退款订单"
        self.view.backgroundColor = CMCColor.loginViewBackgroundColor
        self.configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.presenter.orderEntity == nil {
            //self.tableView?.mj_header.beginRefreshing()
            self.getOrderDetail()
        }
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
        
        self.tableView?.register(UINib(nibName: "RefundInfoTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: RefundInfoTableViewCell.className)
        
        //OrderDetailInfoTableViewCell
        self.tableView?.register(OrderDetailInfoTableViewCell.classForCoder(),
                                 forCellReuseIdentifier: OrderDetailInfoTableViewCell.className)
        
        //RefundActionTableViewCell
        self.tableView?.register(UINib(nibName: "RefundActionTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: RefundActionTableViewCell.className)
        
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


    func getNumberOfRowInSection(section: Int) -> Int {
        if section == 0 {
            return 2
        }
        if section == 1 {
            return 2
        }
        if section == 2 {
            if let itemCount = self.presenter.orderEntity?.order?.sub_list?.count {
                return itemCount + 3
            }
            return 3
        }
        return 0
    }
    
    /// 同意退款
    ///
    /// - Parameter sender:
    func agreedButtonPressed(sender: UIButton) -> Void {
        
        //self.presenter.re
        
        self.presenter.refunDispose(status: "2", status_reason: "")
    }
    
    var saveAlertAction: UIAlertAction?
    /// 拒绝退款
    ///
    /// - Parameter sender:
    func disAgreedButtonPressed(sender: UIButton) -> Void {
        
        func removeNotification(textField: UITextField) {
            NotificationCenter.default.removeObserver(self,
                                                      name: NSNotification.Name.UITextFieldTextDidChange,
                                                      object: textField)
        }
        
        let alert = UIAlertController(title: "拒绝退款", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "请输入拒绝退款理由"
            textField.borderStyle = UITextBorderStyle.none
            
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(RefundOrderDetailView.handleTextFieldTextDidChangeNotification(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
        }
        alert.addAction(UIAlertAction(title: "取消",
                                      style: UIAlertActionStyle.cancel,
                                      handler: { (alertAction) in
                                        removeNotification(textField:  alert.textFields!.first!)
        }))
        
        saveAlertAction = UIAlertAction(title: "保存",
                                        style: UIAlertActionStyle.default,
                                        handler: { (alertAction) in
                                            
                                            removeNotification(textField:  alert.textFields!.first!)
                                            
                                            let refuReason = alert.textFields?[0].text ?? ""
                                            log.info("refuReason: \(refuReason)")
                                            self.presenter.refunDispose(status: "3", status_reason: refuReason)
        })
        
        saveAlertAction?.isEnabled = false
        
        alert.addAction(saveAlertAction!)
        self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) -> Void {
        let textField = notification.object as! UITextField
        saveAlertAction?.isEnabled = textField.text!.length > 0
    }
    
}

//MARK: - Public interface
extension RefundOrderDetailView: RefundOrderDetailViewInterface {
    
    func finishedLoadOrderInfo() {
        self.tableView?.mj_header.endRefreshing()
        self.tableView?.reloadData()
    }
    
    func getOrderDetail() {
        self.presenter.getOrderDetailFromServer()
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension RefundOrderDetailView {
    var presenter: RefundOrderDetailPresenter {
        return _presenter as! RefundOrderDetailPresenter
    }
    var displayData: RefundOrderDetailDisplayData {
        return _displayData as! RefundOrderDetailDisplayData
    }
}
extension RefundOrderDetailView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.presenter.orderEntity == nil {
            return 0
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getNumberOfRowInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let tmpCell = tableView.dequeueReusableCell(withIdentifier: TitleLabelTableViewCell.className,
                                                            for: indexPath) as! TitleLabelTableViewCell
                
                let status_text = ""
                
                tmpCell.rightLabel.textAlignment = NSTextAlignment.left
                tmpCell.configLabtlText(leftLabelAttributeString: NSAttributedString(string: "退款信息 "),
                                        rightLabelAttributeString: NSAttributedString(string: status_text))
                
                cell = tmpCell
            }
            if indexPath.row == 1 {
                
                let tmpCell = tableView.dequeueReusableCell(withIdentifier: RefundInfoTableViewCell.className,
                                                            for: indexPath) as! RefundInfoTableViewCell
                
                if let refundItem = self.presenter.orderEntity?.refund {
                    let mobile = self.presenter.orderEntity!.order!.mobile ?? ""
                    tmpCell.setRefundEntity(refundEntity: refundItem, createUser: mobile)
                }
                
                cell = tmpCell
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let tmpCell = tableView.dequeueReusableCell(withIdentifier: TitleLabelTableViewCell.className,
                                                            for: indexPath) as! TitleLabelTableViewCell
                
                let status_text = ""
                
                tmpCell.rightLabel.textAlignment = NSTextAlignment.left
                tmpCell.configLabtlText(leftLabelAttributeString: NSAttributedString(string: "订单信息 "),
                                        rightLabelAttributeString: NSAttributedString(string: status_text))
                
                cell = tmpCell
            }
            if indexPath.row == 1 {
                
                let tmpCell = tableView.dequeueReusableCell(withIdentifier: OrderDetailInfoTableViewCell.className, for: indexPath) as! OrderDetailInfoTableViewCell
                
                
                tmpCell.setShowTitles(titles: self.presenter.getOrderInfoTitleByStatus(),
                                      values: self.presenter.getOrderInfoArrtibuteList())
                
                cell = tmpCell

            }
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let tmpCell = tableView.dequeueReusableCell(withIdentifier: TitleLabelTableViewCell.className,
                                                            for: indexPath) as! TitleLabelTableViewCell
                
                let status_text = ""
                
                tmpCell.rightLabel.textAlignment = NSTextAlignment.left
                tmpCell.configLabtlText(leftLabelAttributeString: NSAttributedString(string: "商品信息 "),
                                        rightLabelAttributeString: NSAttributedString(string: status_text))
                
                cell = tmpCell
            }
            else if indexPath.row == self.getNumberOfRowInSection(section: indexPath.section) - 1 {
                
                
                let tmpCell = tableView.dequeueReusableCell(withIdentifier: RefundActionTableViewCell.className,
                                                            for: indexPath) as! RefundActionTableViewCell
                
                
                tmpCell.agreeButton.addTarget(self,
                                              action: #selector(RefundOrderDetailView.agreedButtonPressed(sender:)),
                                              for: UIControlEvents.touchUpInside)
                tmpCell.refuseButton.addTarget(self,
                                               action: #selector(RefundOrderDetailView.disAgreedButtonPressed(sender:)),
                                               for: UIControlEvents.touchUpInside)
                
                if self.presenter.needShowRefundButton() {
                    tmpCell.agreeButton.isHidden = false
                    tmpCell.refuseButton.isHidden = false
                    
                    //2017-05-26 16:24:35
                    if let timeValue = self.presenter.orderEntity?.order?.createtime , timeValue.length > 0 {
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let newDate = formatter.date(from: timeValue)
                        if newDate != nil {
                        
                            let timeChunk = TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 7, weeks: 0, months: 0, years: 0)
                            let finalDate = newDate!.add(timeChunk)
                            
                            let betweenChunk = Date().chunkBetween(date: finalDate)
                            
                            var timeString = ""
                            if betweenChunk.days > 0 {
                                timeString += "\(betweenChunk.days)天"
                            }
                            if betweenChunk.hours > 0 {
                                timeString += "\(betweenChunk.hours)小时"
                            }
                            if betweenChunk.minutes > 0 {
                                timeString += "\(betweenChunk.minutes)分钟"
                            }
                            if betweenChunk.seconds > 0 {
                                timeString += "\(betweenChunk.seconds)秒"
                            }
                            
                            let tipMessage = "请在\(timeString)内处理本次退款，如逾期未处理，将自动同意退款"
                            
                            let timeRange = (tipMessage as NSString).range(of: timeString)
                    
                            let attributeString = NSMutableAttributedString(string: tipMessage)
                            attributeString.addAttributes([
                                NSForegroundColorAttributeName : UIColor(hexString: "F75560")!
                                ], range: timeRange)
                            
                            tmpCell.tipLabel.attributedText = attributeString
                        }
                    }
                    
                    if let support_status = self.presenter.orderEntity?.order?.support_status {
                        let refund_status = self.presenter.orderEntity?.refund?.status ?? 0
                        tmpCell.setOrderStatus(support_status: support_status, refund_status: refund_status)
                    }
                    
                }
                else {
                    tmpCell.tipLabel.text = ""
                    tmpCell.agreeButton.isHidden = true
                    tmpCell.refuseButton.isHidden = true
                }
                
                cell = tmpCell
                
            }
            else if indexPath.row == self.getNumberOfRowInSection(section: indexPath.section) - 2 {
                
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
                
                cell = tmpCell
            }
            else {
                
                let skuItemEntity = self.presenter.orderEntity!.order!.sub_list![indexPath.row - 1]
                let tmpCell = tableView.dequeueReusableCell(withIdentifier: SKUItemTableViewCell.className,
                                                            for: indexPath) as! SKUItemTableViewCell
                tmpCell.skuItemEntity = skuItemEntity
                cell = tmpCell
            }
        }
    
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 38
            }
            if indexPath.row == 1 {
                
               return tableView.fd_heightForCell(withIdentifier: RefundInfoTableViewCell.className, configuration: { (cell) in
                    let tmpCell = cell as! RefundInfoTableViewCell
                    
                    if let refundItem = self.presenter.orderEntity?.refund {
                        let mobile = self.presenter.orderEntity!.order!.mobile ?? ""
                        tmpCell.setRefundEntity(refundEntity: refundItem, createUser: mobile)
                    }

                })
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 38
            }
            if indexPath.row == 1 {
                return tableView.fd_heightForCell(withIdentifier: OrderDetailInfoTableViewCell.className, configuration: { (cell) in
                    let tmpCell = cell as! OrderDetailInfoTableViewCell
                    
                    tmpCell.setShowTitles(titles: self.presenter.getOrderInfoTitleByStatus(),
                                          values: self.presenter.getOrderInfoArrtibuteList())
                })
            }
        }
        if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                return 38
            }
            else if indexPath.row == self.getNumberOfRowInSection(section: indexPath.section) - 1 {
                
                if self.presenter.needShowRefundButton() {
                    return 120
                }
                return 0
                
            }
            else if indexPath.row == self.getNumberOfRowInSection(section: indexPath.section) - 2 {
                return 101
            }
            return 113
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
            
            if indexPath.row != self.getNumberOfRowInSection(section: indexPath.section) - 1
                && indexPath.row != self.getNumberOfRowInSection(section: indexPath.section) - 2
                && indexPath.row != 0 {
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
