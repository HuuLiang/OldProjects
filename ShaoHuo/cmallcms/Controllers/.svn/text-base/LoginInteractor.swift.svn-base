//
//  LoginInteractor.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
//import Viperit

final class LoginInteractor: Interactor {
    
    /// 登录
    ///
    /// - Parameters:
    ///   - phoneNumber: 手机号
    ///   - verifyCode: 验证码
    func login(phoneNumber: String, verifyCode: String) -> Void {
        
        let params = [
            "mobile": phoneNumber,
            "vcode": verifyCode,
            "type": "1"
        ]
        
        UserLoginModel.shared.login(params) {
            [weak self] (result, error) in
            self?.presenter.loginResponse(resutl: result, error: error)
        }
        
    }
    
    /// 账号密码登录
    ///
    /// - Parameters:
    ///   - name: 用户名
    ///   - pwd: 密码
    func loginWidthAccount(name: String, pwd: String) -> Void {
        
        let params = [
            "account": name,
            "password": pwd,
            "type": "2"
        ]
        
        UserLoginModel.shared.login(params) {
            [weak self] (result, error) in
            self?.presenter.loginResponse(resutl: result, error: error)
        }
    }
    
    /// 获取验证码
    ///
    /// - Parameter phoneNumber: 电话号码
    func getVerifyCodeFromServer(phoneNumber: String, sms_type: String) -> Void {
        
        let params = [
            "mobile": phoneNumber,
            "sms_type": sms_type
        ]
        
        UserLoginModel.shared.requestVerifyCode(params) {
            [weak self] (error) in
            self?.presenter.verifyCodeResponse(error: error)
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension LoginInteractor {
    var presenter: LoginPresenter {
        return _presenter as! LoginPresenter
    }
}
