//
//  LoginPresenter.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import MBProgressHUD
import EZSwiftExtensions
//import Viperit

final class LoginPresenter: Presenter {
    
    var hud: MBProgressHUD?
    // 是否从服务器获取了验证码
    var isGetVerifyCodeFromServer: Bool = false
    
    override func viewHasLoaded() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.registerUMengForRemoteNotifications()
    }
    /// 登录
    ///
    /// - Parameters:
    ///   - phoneNumber: 手机号 13761506734 123123
    ///   - verifyCode: 验证码
    func login(phoneNumber: String, verifyCode: String) -> Void {
        
        if phoneNumber.length <= 0 {
            _view.showErrorHUDView(errorString: "请输入手机号码")
            return
        }
        
        if verifyCode.length <= 0 {
            _view.showErrorHUDView(errorString: "请输入验证码")
            return
        }
        
        if isGetVerifyCodeFromServer == false {
            _view.showErrorHUDView(errorString: "请先获取验证码")
            return
        }
        
        UserTicketModel.sharedInstance.login_type = .phone
        
        _view.showHUDLoadView()
        interactor.login(phoneNumber: phoneNumber, verifyCode: verifyCode)
        
        //UserTicketModel.sharedInstance.loginType =
    }
    
    /// 账号密码登录
    ///
    /// - Parameters:
    ///   - name: 用户名
    ///   - pwd: 密码
    func loginWidthAccount(name: String, pwd: String) -> Void {
        
        if name.length <= 0 {
            _view.showErrorHUDView(errorString: "请输入账号")
            return
        }
        
        if pwd.length <= 0 {
            _view.showErrorHUDView(errorString: "请输入密码")
            return
        }
        
        UserTicketModel.sharedInstance.login_type = .account
        
        _view.showHUDLoadView()
        interactor.loginWidthAccount(name: name, pwd: pwd)
    }
    
    /// 获取验证码
    ///
    /// - Parameter phoneNumber: 电话号码
    func getVerifyCodeFromServer(phoneNumber: String, sms_type: String = "0") -> Void {
        
        if phoneNumber.length <= 0 {
            _view.showErrorHUDView(errorString: "请输入手机号码")
            view.getVerifyCodeResponse(error: CMCError.verifyTextFieldError(message: "请输入手机号码"))
        }
        else {
            _view.showHUDLoadView()
            interactor.getVerifyCodeFromServer(phoneNumber: phoneNumber, sms_type: sms_type)
        }
        
    }
    
    /// 登录响应
    func loginResponse(resutl: [String: AnyObject]?, error: CMCError?) -> Void {
        
        log.info("login resutl:\(resutl)")
        
        //UserTicketModel.sharedInstance.token = resutl[""]
        
        if let tempError = error {
            
            switch tempError {
            case .jsonSerializedFailed:
                _view.showErrorHUDView(errorString: "登录失败")
            case .responseError(_, let message):
                _view.showErrorHUDView(errorString: message)
            default:
                _view.showErrorHUDView(errorString: "登录失败")
            }
            view.loginFailed()
        }
        else {
             //_view.hidHUDView(hud: hud)
            
            UserTicketModel.sharedInstance.token = resutl!["token"] as? String
            UserTicketModel.sharedInstance.address = resutl!["address"] as? String
            UserTicketModel.sharedInstance.region_id = resutl!["region_id"] as? String
            UserTicketModel.sharedInstance.shop_id = resutl!["shop_id"] as? String
            UserTicketModel.sharedInstance.username = resutl!["username"] as? String
            UserTicketModel.sharedInstance.alias = resutl!["alias"] as? String
            UserTicketModel.sharedInstance.mobile_phone = resutl!["mobile_phone"] as? String
            UserTicketModel.sharedInstance.account = resutl!["account"] as? String
            UserTicketModel.sharedInstance.shop_name = resutl!["shop_name"] as? String
            UserTicketModel.sharedInstance.user_type = resutl!["user_type"] as? String
            UserTicketModel.sharedInstance.uid = resutl!["ad_uid"] as? String
            
            _view.showSuccessHUDView(messageString: "登录成功")

            ez.dispatchDelay(1.5, closure: {
                self.view.loginSuccess()
            })
            
        }
    }
    
    /// 验证码响应
    func verifyCodeResponse(error: CMCError?) -> Void {
        
        if let tempError = error {
            switch tempError {
            case .jsonSerializedFailed, .verifyTextFieldError(_):
                _view.showErrorHUDView(errorString: "获取验证码失败")
            case .responseError( _, let message):
                _view.showErrorHUDView(errorString: message)
            }
            
            view.getVerifyCodeResponse(error: CMCError.verifyTextFieldError(message: ""))
        }
        else {
            isGetVerifyCodeFromServer = true
            _view.showSuccessHUDView(messageString: "验证码发送成功")
            view.getVerifyCodeResponse(error: nil)
        }
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension LoginPresenter {
    var view: LoginViewInterface {
        return _view as! LoginViewInterface
    }
    var interactor: LoginInteractor {
        return _interactor as! LoginInteractor
    }
    var router: LoginRouter {
        return _router as! LoginRouter
    }
}
