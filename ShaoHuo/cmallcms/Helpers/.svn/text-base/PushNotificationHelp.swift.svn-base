//
//  PushNotificationHelp.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/27.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

struct PushNotificationHelp {

    fileprivate static func getIndexPoint(callback: @escaping (_ result: [String: AnyObject]?, _ error: CMCError?) -> Void)  {
        
        if UserTicketModel.sharedInstance.isLogin == false {
            return
        }
        
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? ""
        ]
        
        OrderListModel.shared.getIndexPoint(params) { (result, error) in
            callback(result, error)
        }
    }
    
    static func showBadgeValue() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootViewController = appDelegate.window?.rootViewController as? UITabBarController
        
        let homeTabBarItem: UITabBarItem? =  rootViewController?.tabBar.items?[0]
        let messageTabBarItem: UITabBarItem? =  rootViewController?.tabBar.items?[1]

        
        PushNotificationHelp.getIndexPoint { (result, error) in
            if let tmpError = error {
                log.info("getIndexPoint: \(tmpError.debugDescription)")
            }
            else {
                if let order_point = result?["order_point"] as? String {
                    homeTabBarItem?.badgeValue = order_point == "0" ? nil : order_point
                }
                else {
                    homeTabBarItem?.badgeValue = nil
                }
                
                if let push_point = result?["push_point"] as? String {
                    messageTabBarItem?.badgeValue = push_point == "0" ? nil : push_point
                    
//                    if let navigationController: UINavigationController = rootViewController?.viewControllers?[0] as? UINavigationController {
//                    
//                        if let tmpMessageView = navigationController.topViewController as? MessageView {
//                            tmpMessageView.getMessageList(reload: true)
//                        }
//                    }
                }
                else {
                    messageTabBarItem?.badgeValue = nil
                }
            }
        }
    }
    
    static func didReceiveRemoteNotification(userInfo: [AnyHashable : Any], needShowOrderDetailView: Bool = false) -> Void {
        
        if UserTicketModel.sharedInstance.isLogin == false {
            return
        }
        
        let dicData = userInfo as? [String : AnyObject]
        let aps = dicData?["aps"] as? [String : AnyObject]
        
        if let title = aps?["alert"] as? String {
            log.info("title: \(title)")
        }
        
        //var badge = aps?["badge"] as? Int
        //log.info("badge: \(String(describing: badge ?? 0))")
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootViewController = appDelegate.window?.rootViewController as? UITabBarController
        
//        let homeTabBarItem: UITabBarItem? =  rootViewController?.tabBar.items?[0]
//        let messageTabBarItem: UITabBarItem? =  rootViewController?.tabBar.items?[1]
        /*
        if badge == nil {
            badge = 1
        }
        
        if let badgeValue = messageTabBarItem?.badgeValue?.toInt() {
            messageTabBarItem?.badgeValue = "\(badgeValue + (badge ?? 0))"
        }
        else {
            messageTabBarItem?.badgeValue = "\(String(describing: badge ?? 0))"
        }
        */
        
        if needShowOrderDetailView {
            if let order_id = dicData?["order_id"] {
                if let navigationController: UINavigationController = rootViewController?.viewControllers?[0] as? UINavigationController {
                    
                    let detailModel = Module.build("OrderDetail")
                    detailModel.view.hidesBottomBarWhenPushed = true
                    detailModel.router.show(from: navigationController,
                                            embedInNavController: false,
                                            setupData: order_id)
                    //detailModel.router.showDetail(from: navigationController, setupData: order_id)
                }
            }
        }
        
        PushNotificationHelp.showBadgeValue()
    }
    /// 清楚 badgeValue
    ///
    /// - Parameter tabBarItem:
    static func cleanBadgeValue(tabBarItem: UITabBarItem? = nil) {
        tabBarItem?.badgeValue = nil
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
