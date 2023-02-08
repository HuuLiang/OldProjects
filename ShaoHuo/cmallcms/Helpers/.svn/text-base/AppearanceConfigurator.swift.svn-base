//
//  AppearanceConfigurator.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/20.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import SVProgressHUD

class AppearanceConfigurator {
    
    class func configureNavigationBar() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        /*
         导航栏色值
         */
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        UINavigationBar.appearance().tintColor = UIColor.white //UIColor.blackColor() //
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 20)
        ]
    }
    
    class func configureSVProgressHUD() {
       
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        SVProgressHUD.setForegroundColor(UIColor.white)
        
    }
}

