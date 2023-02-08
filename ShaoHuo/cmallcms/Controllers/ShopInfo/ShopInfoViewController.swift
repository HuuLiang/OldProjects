//
//  ShopInfoViewController.swift
//  cmallcms
//
//  Created by vicoo on 2017/6/23.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class ShopInfoViewController: UIViewController {
    
    var shopInfo: [String : AnyObject]?
    
    var tableView: UITableView!
    
    let cellIdentifier = "CellIdentifer"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.lt_setBackgroundGradientColor(colors: CMCColor.navbarGradientColor,
                                                                               startPoint: CGPoint(x: 0, y: 0),
                                                                               endPoint: CGPoint(x: 1, y: 0),
                                                                               locations: [0, 0.65, 1.0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configTableView() -> Void {
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.grouped)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.mas_makeConstraints { (make) in
            let _ = make?.top.equalTo()(0)
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.bottom.equalTo()(0)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShopInfoViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.textColor = UIColor(hexString: "333333")
            //cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        if indexPath.row == 0 {
            cell?.imageView?.image = UIImage(named: "icon_my_shop")
            
            if let shop_name = self.shopInfo?[ShopInfoKey.shop_name] {
                cell?.textLabel?.text = "店铺名称：\(shop_name)"
            }
            else {
                cell?.textLabel?.text = "店铺名称："
            }
            
        }
        if indexPath.row == 1 {
            cell?.imageView?.image = UIImage(named: "icon_my_phone")
            cell?.textLabel?.text = "联系方式：\(UserTicketModel.sharedInstance.mobile_phone ?? "")"
        }
        if indexPath.row == 2 {
            cell?.imageView?.image = UIImage(named: "icon_my_worktime")
            
            if let business_time = self.shopInfo?[ShopInfoKey.business_time] {
                //let business_end_time = self.presenter.shopInfo?["business_end_time"] as? String
                
                cell?.textLabel?.text = "营业时间：\(business_time)"
            }
            else {
                cell?.textLabel?.text = "营业时间："
            }
            
        }
        if indexPath.row == 3 {
            cell?.imageView?.image = UIImage(named: "icon_my_addr")
            
            if let shop_address = self.shopInfo?[ShopInfoKey.shop_address] {
                cell?.textLabel?.text = "店铺地址：\(shop_address)"
            }
            else {
                cell?.textLabel?.text = "店铺地址："
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}
