//
//  AppDelegate.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/17.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let printConnectController = GPrintConnectViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = CMCColor.viewBackgroundColor
        
        AppearanceConfigurator.configureNavigationBar()
        AppearanceConfigurator.configureSVProgressHUD()
        
        self.configUMessage(launchOptions: launchOptions)
        
        self.showGuideViewController()
        
        window?.makeKeyAndVisible()
        
        if let notificaton = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            PushNotificationHelp.didReceiveRemoteNotification(userInfo: notificaton as! [AnyHashable : Any], needShowOrderDetailView: true)
            //应用处于后台时的远程推送接受
            UMessage.didReceiveRemoteNotification(notificaton as? [AnyHashable : Any])
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        PushNotificationHelp.cleanBadgeValue()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if UserTicketModel.sharedInstance.isLogin == true {
            PushNotificationHelp.showBadgeValue()
            let rootViewController = self.window?.rootViewController as? UITabBarController
            if let navigationController: UINavigationController = rootViewController?.viewControllers?[0] as? UINavigationController {
                
                if let tmp_home_view = navigationController.topViewController as? HomeView {
                    tmp_home_view.getNewOrderList()
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
//    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
//        
//    }
    
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
//        UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
        
        log.info("remoteNotificaton: \(userInfo)")
        PushNotificationHelp.didReceiveRemoteNotification(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let notificationTokenString = deviceToken.hexString
        log.info("notificationTokenString: \(notificationTokenString)")
    }
}

extension AppDelegate {
    
    /// 注册远程通知
    ///
    /// - Parameter launchOptions:
    func configUMessage(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        UMessage.start(withAppkey: CMCConfig.UMengPushAppKey,
                       launchOptions: launchOptions,
                       httpsEnable: true)
        
        
        if UserTicketModel.sharedInstance.isLogin {
            self.registerUMengForRemoteNotifications()
        }
        
        //UMConfigInstance.appKey = CMCConfig.UMengPushAppKey
        let analyticsConfig = UMAnalyticsConfig.sharedInstance()
        analyticsConfig?.channelId = "App Store"
        analyticsConfig?.appKey = CMCConfig.UMengPushAppKey
        
        MobClick.start(withConfigure: analyticsConfig)
    }
    
    func registerUMengForRemoteNotifications() {
        
        UMessage.registerForRemoteNotifications()
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound],
                                        completionHandler: {
                                            (granted, error) in
                                            
                                            if granted {
                                                //点击允许
                                            }
                                            else {
                                                //点击不允许
                                            }
            })
        }
//        else {
//            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(setting)
//        }
        UMessage.setLogEnabled(true)
    }
    
    /// 显示指引界面
    func showGuideViewController() {
        if UserTicketModel.sharedInstance.isFirstLaunch() {
            log.info("User is first launch app")
            let guideViewController = GuideViewController()
            self.window?.rootViewController = guideViewController
        }
        else {
            log.info("User is not first launch app")
            self.showLoginViewController()
        }
    }
    
    /// 显示登录
    func showLoginViewController() {
        if UserTicketModel.sharedInstance.isLogin {
            self.showTabbarViewController()
        }
        else {
            let loginModle = Module.build("Login")
            loginModle.view.title = "登录"
            let loginNavigationController = UINavigationController(rootViewController: loginModle.view)
            self.window?.rootViewController = loginNavigationController
            
            loginNavigationController.navigationBar.lt_setBackgroundGradientColor(
                                                            colors: CMCColor.navbarGradientColor,
                                                            startPoint: CGPoint(x: 0, y: 0),
                                                            endPoint: CGPoint(x: 1, y: 0),
                                                            locations: [0, 0.65, 1.0])
        }
    }
    
    /// 显示tabbar
    func showTabbarViewController() {
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: CMCColor.normalButtonBackgroundColor,
            NSFontAttributeName: UIFont.systemFont(ofSize: 12)
            ], for: UIControlState.normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: CMCColor.hlightedButtonBackgroundColor,
            NSFontAttributeName: UIFont.systemFont(ofSize: 12)
            ], for: UIControlState.selected)
        
        let homeModule = Module.build("Home")
        homeModule.view.title = "订单"
        homeModule.view.tabBarItem.image = UIImage(named: "home")
        homeModule.view.tabBarItem.selectedImage = UIImage(named: "home_1")!.withRenderingMode(.alwaysOriginal)
        let v1 = UINavigationController(rootViewController: homeModule.view)
        
        
        let messageModule = Module.build("Message")
        messageModule.view.title = "消息"
        messageModule.view.tabBarItem.image = UIImage(named: "message")
        messageModule.view.tabBarItem.selectedImage = UIImage(named: "message_1")!.withRenderingMode(.alwaysOriginal)
        let v2 = UINavigationController(rootViewController: messageModule.view)
        
        let myModule = Module.build("My")
        myModule.view.title = "我的"
        myModule.view.tabBarItem.image = UIImage(named: "me")
        myModule.view.tabBarItem.selectedImage = UIImage(named: "me_1")!.withRenderingMode(.alwaysOriginal)
        let v3 = UINavigationController(rootViewController: myModule.view)
        
        
        v1.navigationBar.lt_setBackgroundGradientColor(colors: CMCColor.navbarGradientColor,
                                                       startPoint: CGPoint(x: 0, y: 0),
                                                       endPoint: CGPoint(x: 1, y: 0),
                                                       locations: [0, 0.65, 1.0])
        
        v2.navigationBar.lt_setBackgroundGradientColor(colors: CMCColor.navbarGradientColor,
                                                       startPoint: CGPoint(x: 0, y: 0),
                                                       endPoint: CGPoint(x: 1, y: 0),
                                                       locations: [0, 0.65, 1.0])
        
        v3.navigationBar.lt_setBackgroundGradientColor(colors: CMCColor.navbarGradientColor,
                                                       startPoint: CGPoint(x: 0, y: 0),
                                                       endPoint: CGPoint(x: 1, y: 0),
                                                       locations: [0, 0.65, 1.0])
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers =  [v1,v2,v3]
        tabBarController.tabBar.barTintColor = UIColor.white
        tabBarController.tabBar.tintColor = UIColor(hexString: "F95F17")
        //tabBarController.tabBar.s
        
        self.window?.rootViewController = tabBarController
        
        
        
        /*
        v1.tabBarItem = ESTabBarItem.init(title: "定单",
                                          image: UIImage(named: "home"),
                                          selectedImage: UIImage(named: "home_1")!.withRenderingMode(.alwaysTemplate))
        v2.tabBarItem = ESTabBarItem.init(title: "消息",
                                          image: UIImage(named: "message"),
                                          selectedImage: UIImage(named: "message_1")!.withRenderingMode(.alwaysOriginal))
        v3.tabBarItem = ESTabBarItem.init(title: "我的",
                                          image: UIImage(named: "me"),
                                          selectedImage: UIImage(named: "me_1")!.withRenderingMode(.alwaysOriginal))
        
        //_ = UIImage(named: "home_1")!.withRenderingMode(.alwaysOriginal)
        
        //img?.renderingMode = UIImageRenderingMode.alwaysOriginal
        
        let tabBarController = ESTabBarController()
        tabBarController.viewControllers = [v1,v2,v3]
        
        tabBarController.tabBar.backgroundColor = UIColor.white
        
        self.window?.rootViewController = tabBarController
         */
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let trigger = response.notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.classForCoder()) {
            //应用处于后台时的远程推送接受
            UMessage.didReceiveRemoteNotification(userInfo)
            
            log.info("userNotificationCenter:\(userInfo)")
            
            PushNotificationHelp.didReceiveRemoteNotification(userInfo: userInfo)
        } else {
            //应用处于后台时的本地推送接受
        }
        //completionHandler()
    }
    
    //iOS10新增：处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        if let trigger = notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.classForCoder()) {
            //应用处于后台时的远程推送接受
            UMessage.didReceiveRemoteNotification(userInfo)
            
            log.info("userNotificationCenter:\(userInfo)")
            
            PushNotificationHelp.didReceiveRemoteNotification(userInfo: userInfo)
        } else {
            //应用处于后台时的本地推送接受
        }
        //如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
        completionHandler([.alert, .sound, .badge])
    }
}

// MARK: - APNS ID
private extension Data {
    var hexString: String {
        return withUnsafeBytes {(bytes: UnsafePointer<UInt8>) -> String in
            let buffer = UnsafeBufferPointer(start: bytes, count: count)
            return buffer.map {String(format: "%02hhx", $0)}.reduce("", { $0 + $1 })
        }
    }
}
