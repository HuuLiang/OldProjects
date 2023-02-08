//
//  ShopListViewController.swift
//  cmallcms
//
//  Created by vicoo on 2017/6/28.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ShopListViewController: UIViewController {
    
    var tableView: UITableView?
    
    var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.selectedIndex = UserTicketModel.sharedInstance.shop_list.index { (item) -> Bool in
//            return item.shop_id! == UserTicketModel.sharedInstance.shop_id
//        }!
        
        for (idx, item) in UserTicketModel.sharedInstance.shop_list.enumerated() {
            if item.shop_id == UserTicketModel.sharedInstance.shop_id {
                self.selectedIndex = idx
                break
            }
        }

        tableView = UITableView(frame: CGRect(x: 0, y: 0, w: ez.screenWidth, h: ez.screenHeight - 44),
                                style: UITableViewStyle.plain)
        view.addSubview(tableView!)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = 57
        tableView?.tableFooterView = UIView()
        
        let tableFooterView = UIView(frame: CGRect(x: 0, y: ez.screenHeight - 44, w: ez.screenWidth, h: 44))
        view.addSubview(tableFooterView)
        
        let nextButton = UIButton(type: UIButtonType.custom)
        nextButton.setTitle("下一步", for: UIControlState.normal)
        nextButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        nextButton.frame = CGRect(x: 0, y: 0, w: ez.screenWidth, h: 44)
        tableFooterView.addSubview(nextButton)
        nextButton.backgroundColor = UIColor(hexString: "FA6B1F")
        nextButton.addTarget(self, action: #selector(ShopListViewController.nextBtnPressed(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    func nextBtnPressed(sender: UIButton) {
        
        let item = UserTicketModel.sharedInstance.shop_list[selectedIndex]
        // 账号切换
        if UserTicketModel.sharedInstance.shop_id != item.shop_id {
            
            UserTicketModel.sharedInstance.shop_id = item.shop_id ?? ""
            UserTicketModel.sharedInstance.shop_name = item.shop_name ?? ""
            UserTicketModel.sharedInstance.uid = item.ad_uid ?? ""
            UserTicketModel.sharedInstance.alias = item.alias ?? ""
            UserTicketModel.sharedInstance.token = item.token ?? ""
            UserTicketModel.sharedInstance.user_type = item.user_type ?? ""
            
            // 设置别名
            if let alias = UserTicketModel.sharedInstance.alias {
                UMessage.addAlias(alias, type: "ishaohuo", response: { (responseObject, error) in
                    log.info("responseObject: \(responseObject)")
                })
            }
            
            self.callBack?(true)
        }
        let _ = self.navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var callBack: ((_ needReload: Bool) -> Void)?
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ShopListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserTicketModel.sharedInstance.shop_list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CellIdentifier")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.textColor = UIColor(hexString: "333333")
        }
        
        let item = UserTicketModel.sharedInstance.shop_list[indexPath.row]
        
        cell?.textLabel?.text = " \(item.shop_name ?? "")"
        
        if indexPath.row == self.selectedIndex {
            cell?.imageView?.image = UIImage(named: "icon_check_selected")
        }
        else {
            cell?.imageView?.image = UIImage(named: "icon_check_normal")
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedIndex = indexPath.row
        
        tableView.reloadData()
    }
}
