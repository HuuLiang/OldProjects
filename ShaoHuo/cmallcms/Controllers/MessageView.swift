//
//  MessageView.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import MJRefresh
import DZNEmptyDataSet

//MARK: - Public Interface Protocol
protocol MessageViewInterface {
    
    func noMoreData()
    func finishedLoad()
}

//MARK: Message View
final class MessageView: UserInterface {
    
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getMessageList(reload: true)
    }
    
    func configTableView() -> Void {
        let tableViewFrame = CGRect(x: 0, y: 0, w: self.view.w, h: self.view.h)
        self.tableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.plain)
        self.view.addSubview(self.tableView!)
        self.tableView?.tableFooterView = UIView()
        self.tableView?.backgroundColor = UIColor.clear
        
        
        self.tableView?.register(UINib(nibName: "MessageListTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: MessageListTableViewCell.className)
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.tableView?.separatorInset = UIEdgeInsets.zero
        self.tableView?.layoutMargins = UIEdgeInsets.zero
        
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 60
        
        self.tableView?.emptyDataSetSource = self
        self.tableView?.emptyDataSetDelegate = self
        //self.tableView?.tableFooterView = UIView()
        
        let refreshHeader = MJRefreshNormalHeader {
            [weak self] in
            self?.getMessageList(reload: true)
        }
        
        refreshHeader?.lastUpdatedTimeLabel.isHidden = true
        self.tableView?.mj_header = refreshHeader
        
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            [weak self] in
            //self?.getOrderList(status: self?.segmentedControl.selectedSegmentIndex ?? 0)
            self?.getMessageList(reload: false)
        })
    }
    
    func getMessageList(reload: Bool) {
        self.presenter.getMessageList(isReload: reload)
    }
}

//MARK: - Public interface
extension MessageView: MessageViewInterface {
    
    func noMoreData() {
//        self.tableView?.mj_header.endRefreshing()
//        self.tableView?.mj_footer.endRefreshing()
        self.tableView?.reloadData()
        self.tableView?.mj_header.endRefreshing()
        self.tableView?.mj_footer.endRefreshingWithNoMoreData()
        //elf.tableView?.reloadData()
    }
    
    func finishedLoad() {
        self.tableView?.mj_header.endRefreshing()
        self.tableView?.mj_footer.endRefreshing()
        
        self.tableView?.reloadData()
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension MessageView {
    var presenter: MessagePresenter {
        return _presenter as! MessagePresenter
    }
    var displayData: MessageDisplayData {
        return _displayData as! MessageDisplayData
    }
}

extension MessageView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let itemEntity = self.presenter.orderList[section]
        return self.presenter.messageList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageListTableViewCell.className, for: indexPath) as?  MessageListTableViewCell
        if self.presenter.messageList.count > 0 {
            let msgItem = self.presenter.messageList[indexPath.row]
            cell?.msgItemEntity = msgItem
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return tableView.fd_heightForCell(withIdentifier: MessageListTableViewCell.className) { (cell) in
            let tmpCell = cell as! MessageListTableViewCell
            if self.presenter.messageList.count > 0 {
                let msgItem = self.presenter.messageList[indexPath.row]
                tmpCell.msgItemEntity = msgItem
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let msgItem = self.presenter.messageList[indexPath.row]
        if msgItem.read_status == 1 {
            self.presenter.readMessage(index: indexPath.row)
        }
        if let order_id = msgItem.order_id {
            let orderDetailModel = Module.build("OrderDetail")
            orderDetailModel.view.hidesBottomBarWhenPushed = true
            orderDetailModel.router.show(from: self.navigationController!,
                                         embedInNavController: false,
                                         setupData: order_id)
        }
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.delete
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.presenter.deleteMessage(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}

extension MessageView : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "icon_no_message")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributeString = NSMutableAttributedString(string: "暂无消息")
        
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
