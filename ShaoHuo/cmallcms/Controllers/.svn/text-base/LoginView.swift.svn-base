//
//  LoginView.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import TYAttributedLabel

//MARK: - Public Interface Protocol
protocol LoginViewInterface {
    func getVerifyCodeResponse(error: CMCError?)
    func loginSuccess()
    func loginFailed()
}

//MARK: Login View
final class LoginView: UserInterface {
    
    var segmentedControl: HMSegmentedControl!

    /// 手机号登录
    var phoneLoginContentView: UIView!
    var phoneLeftImageView: UIImageView!
    var phoneNumberTextField: UITextField!
    var verifyCodeLeftImageView: UIImageView!
    var verifyCodeTextField: UITextField!
    var verifyCodeButton: CMCActionButton!
    
    /// 账号密码登录
    var accountLoginContentView: UIView!
    var accountLeftImageView: UIImageView!
    var accountNameTextField: UITextField!
    var passwordLeftImageView: UIImageView!
    var passwordTextField: UITextField!
    
    /// logo
    var loginLogoImageView: UIImageView!
    
    /// 登录按钮
    var loginButton: UIButton!
    
    var remarkLabel: TYAttributedLabel!
    
    /// 到计时
    var verifyCodeTime: Timer?
    
    var lineView: UIView {
        get {
            let tmpLineView: UIView = UIView(frame: CGRect(x: 0, y: 0, w: self.view.w, h: 1/UIScreen.main.scale))
            tmpLineView.cmc_drawLineStroke(width: 1/UIScreen.main.scale, color: CMCColor.normalLineColor)
            return tmpLineView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = CMCColor.loginViewBackgroundColor
        
        self.configSegmentio()
        self.configLoginLogoView()
        self.configPhoneLoginView()
        self.configAccountLoginView()
        self.configLoginButton()
        self.configRemarkLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    deinit {
        verifyCodeTime?.invalidate()
        verifyCodeTime = nil
    }
    
    //MARK: - Private Methods
    func configSegmentio() {
        segmentedControl = HMSegmentedControl(sectionTitles: ["手机号登录","账号登录"])
        segmentedControl.autoresizingMask = UIViewAutoresizing.flexibleWidth
        segmentedControl.frame = CGRect(x: 0, y: 64, w: self.view.w, h: 47)
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segmentedControl.isVerticalDividerEnabled = false
        
        
        segmentedControl.titleTextAttributes = [
            NSForegroundColorAttributeName : CMCColor.normalButtonBackgroundColor,
            NSFontAttributeName : UIFont.systemFont(ofSize: 17)
        ]
        
        segmentedControl.selectedTitleTextAttributes = [
            NSForegroundColorAttributeName : CMCColor.hlightedButtonBackgroundColor,
            NSFontAttributeName : UIFont.systemFont(ofSize: 17)
        ]
        
        segmentedControl.selectionIndicatorColor = CMCColor.hlightedButtonBackgroundColor
        segmentedControl.selectionIndicatorHeight = 4
        
        segmentedControl.borderType = HMSegmentedControlBorderType.bottom
        segmentedControl.borderColor = CMCColor.segmentedBorderColor
        segmentedControl.borderWidth = 1
        
        self.view.addSubview(segmentedControl)
        
        segmentedControl.indexChangeBlock = {
            [weak self] index in
            self?.loginContentViewAnimation(index: index)
        }
        
        
    }
    
    /// 切换登录视图
    ///
    /// - Parameter index:
    func loginContentViewAnimation(index: Int) {
        /*
        let orignX: CGFloat = index == 0 ? 0 : -self.view.w
        let accountViewOrignX: CGFloat = index == 1 ? 0 : self.view.w
        
        self.phoneLoginContentView.mas_updateConstraints { (make) in
            let _ = make?.left.equalTo()(orignX)
        }
        
        self.accountLoginContentView.mas_updateConstraints({ (make) in
            let _ = make?.left.equalTo()(accountViewOrignX)
        })
        */
        self.remarkLabel.isHidden = index == 0
        self.phoneLoginContentView.isHidden = index == 1
        self.accountLoginContentView.isHidden = index == 0
        
        if index == 0 {
            
            self.phoneNumberTextField.becomeFirstResponder()
        }
        else {
            self.accountNameTextField.becomeFirstResponder()
        }
        /*
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.phoneLoginContentView.layoutIfNeeded()
         
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.accountLoginContentView.layoutIfNeeded()
        }) { (_) in
            self.remarkLabel.isHidden = index == 0
        }*/
        
 
    }
    
    func configLoginLogoView() {
        loginLogoImageView = UIImageView(image: UIImage(named: "icon_login_logo"))
        view.addSubview(loginLogoImageView)
        
        loginLogoImageView.mas_makeConstraints { (make) in
            let _ = make?.top.equalTo()(131)
            let _ = make?.width.equalTo()(115)
            let _ = make?.height.equalTo()(115)
            let _ = make?.centerX.equalTo()(0)
        }
    }
    
    func configPhoneLoginView() {
        phoneLoginContentView = UIView()
        view.addSubview(phoneLoginContentView)
        phoneLoginContentView.backgroundColor = UIColor.white
        
        phoneLoginContentView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.height.equalTo()(94)
            let _ = make?.top.equalTo()(self.loginLogoImageView.mas_bottom)!.setOffset(20)
        }
        // topLine
        let topLineView = self.lineView
        phoneLoginContentView.addSubview(topLineView)
        topLineView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.height.equalTo()(1)
            let _ = make?.top.equalTo()(0)
        }
        // centerLine
        let centerLineView = self.lineView
        phoneLoginContentView.addSubview(centerLineView)
        centerLineView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.height.equalTo()(1)
            let _ = make?.centerY.equalTo()(0)
        }
        // bottomLine
        let bottomLineView = self.lineView
        phoneLoginContentView.addSubview(bottomLineView)
        bottomLineView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.height.equalTo()(1)
            let _ = make?.bottom.equalTo()(0)
        }
        
        phoneLeftImageView = UIImageView(image: UIImage(named: "icon_login_phone"))
        phoneLoginContentView.addSubview(phoneLeftImageView)
        
        phoneNumberTextField = UITextField()
        phoneLoginContentView.addSubview(phoneNumberTextField)
        phoneNumberTextField.keyboardType = UIKeyboardType.phonePad
        phoneNumberTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        phoneNumberTextField.font = UIFont.systemFont(ofSize: 15)
        phoneNumberTextField.placeholder = "请输入11位手机号码"
        phoneNumberTextField.limitTextLength(11)
        
        //16 21
        phoneLeftImageView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(14)
            let _ = make?.top.equalTo()(13)
            let _ = make?.width.equalTo()(16)
            let _ = make?.height.equalTo()(21)
        }
        
        phoneNumberTextField.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(self.phoneLeftImageView.mas_right)?.setOffset(14)
            let _ = make?.top.equalTo()(14)
            let _ = make?.right.equalTo()(-14)
            let _ = make?.height.equalTo()(20)
        }
        
        verifyCodeLeftImageView = UIImageView(image: UIImage(named: "icon_login_code"))
        phoneLoginContentView.addSubview(verifyCodeLeftImageView)
        
        verifyCodeTextField = UITextField()
        phoneLoginContentView.addSubview(verifyCodeTextField)
        verifyCodeTextField.keyboardType = UIKeyboardType.phonePad
        verifyCodeTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        verifyCodeTextField.font = UIFont.systemFont(ofSize: 15)
        verifyCodeTextField.placeholder = "请输入4位短信验证码"
        verifyCodeTextField.limitTextLength(6)
        
        // 35 40
        verifyCodeLeftImageView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(14)
            let _ = make?.bottom.equalTo()(-14)
            let _ = make?.width.equalTo()(17.5)
            let _ = make?.height.equalTo()(20)
        }
        
        verifyCodeTextField.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(self.phoneLeftImageView.mas_right)?.setOffset(14)
            let _ = make?.bottom.equalTo()(-13)
            let _ = make?.width.equalTo()(150)
            let _ = make?.height.equalTo()(20)
        }
        
        verifyCodeButton = CMCActionButton(frame: CGRect(x: 0, y: 0, w: 81, h: 25))
        verifyCodeButton.setTitle("获取验证码", for: UIControlState.normal)
        verifyCodeButton.setTitle("60秒后重新获取", for: UIControlState.disabled)
        phoneLoginContentView.addSubview(verifyCodeButton)
        
        verifyCodeButton.mas_makeConstraints { (make) in
            let _ = make?.right.equalTo()(-14)
            let _ = make?.height.equalTo()(25)
            let _ = make?.width.equalTo()(81)
            let _ = make?.bottom.equalTo()(-8.5)
        }
        
        verifyCodeButton.addTarget(self, action: #selector(LoginView.verifyCodeButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    func configAccountLoginView() {
        accountLoginContentView = UIView()
        view.addSubview(accountLoginContentView)
        
        accountLoginContentView.backgroundColor = UIColor.white
        
        accountLoginContentView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.height.equalTo()(94)
            let _ = make?.top.equalTo()(self.loginLogoImageView.mas_bottom)!.setOffset(20)
        }
        
        // topLine
        let topLineView = self.lineView
        accountLoginContentView.addSubview(topLineView)
        topLineView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.height.equalTo()(1)
            let _ = make?.top.equalTo()(0)
        }
        // centerLine
        let centerLineView = self.lineView
        accountLoginContentView.addSubview(centerLineView)
        centerLineView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.height.equalTo()(1)
            let _ = make?.centerY.equalTo()(0)
        }
        // bottomLine
        let bottomLineView = self.lineView
        accountLoginContentView.addSubview(bottomLineView)
        bottomLineView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(0)
            let _ = make?.right.equalTo()(0)
            let _ = make?.height.equalTo()(1)
            let _ = make?.bottom.equalTo()(0)
        }
        
        
        accountLeftImageView = UIImageView(image: UIImage(named: "icon_login_account"))
        accountLoginContentView.addSubview(accountLeftImageView)
        
        accountNameTextField = UITextField()
        accountLoginContentView.addSubview(accountNameTextField)
        accountNameTextField.keyboardType = UIKeyboardType.default
        accountNameTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        accountNameTextField.font = UIFont.systemFont(ofSize: 15)
        accountNameTextField.placeholder = "请输入账号"
        accountNameTextField.limitTextLength(20)
        
        //16 21
        accountLeftImageView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(14)
            let _ = make?.top.equalTo()(13.5)
            let _ = make?.width.equalTo()(17)
            let _ = make?.height.equalTo()(20)
        }
        
        accountNameTextField.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(self.accountLeftImageView.mas_right)?.setOffset(14)
            let _ = make?.top.equalTo()(14)
            let _ = make?.right.equalTo()(-14)
            let _ = make?.height.equalTo()(20)
        }
        
        passwordLeftImageView = UIImageView(image: UIImage(named: "icon_login_pwd"))
        accountLoginContentView.addSubview(passwordLeftImageView)
        
        passwordTextField = UITextField()
        accountLoginContentView.addSubview(passwordTextField)
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.placeholder = "请输入密码"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.limitTextLength(20)
        
        // 35 40
        passwordLeftImageView.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(14)
            let _ = make?.bottom.equalTo()(-14)
            let _ = make?.width.equalTo()(17.5)
            let _ = make?.height.equalTo()(21)
        }
        
        passwordTextField.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(self.accountLeftImageView.mas_right)?.setOffset(14)
            let _ = make?.bottom.equalTo()(-13)
            let _ = make?.right.equalTo()(-14)
            let _ = make?.height.equalTo()(20)
        }
        
        self.accountLoginContentView.isHidden = true
    }
    
    func configLoginButton() {
        loginButton = UIButton(type: UIButtonType.custom)
        loginButton.setBackgroundColor(CMCColor.hlightedButtonBackgroundColor, forState: UIControlState.normal)
        loginButton.setBackgroundColor(CMCColor.normalButtonBackgroundColor, forState: UIControlState.highlighted)
        loginButton.setTitle("立即登录", for: UIControlState.normal)
        loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.view.addSubview(loginButton)
        
        loginButton.addTarget(self,
                              action: #selector(LoginView.loginButtonPressed(sender:)),
                              for: UIControlEvents.touchUpInside)
        
        loginButton.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(14)
            let _ = make?.right.equalTo()(-14)
            let _ = make?.top.equalTo()(self.phoneLoginContentView.mas_bottom)?.setOffset(14)
            let _ = make?.height.equalTo()(44)
        }
        
        loginButton.layer.cornerRadius = 3
        loginButton.layer.masksToBounds = true
        
        
    }
    
    func configRemarkLabel() {
        
        let tipTextString = "如忘记密码，请点击拔打客服热线："
        let remarkTextString = "\(tipTextString)\(CMCConfig.CustomServicePhoneNumber)"
        
        let textStorage = TYTextStorage()
        textStorage.font = UIFont.systemFont(ofSize: 12)
        textStorage.textColor = UIColor(hexString: "646464")
        textStorage.range = (remarkTextString as NSString).range(of: tipTextString)
       
        let linkTextStorage = TYLinkTextStorage()
        linkTextStorage.font = UIFont.systemFont(ofSize: 12)
        linkTextStorage.textColor = UIColor(hexString: "1079fc")
        linkTextStorage.range = (remarkTextString as NSString).range(of: CMCConfig.CustomServicePhoneNumber)
        linkTextStorage.linkData = CMCConfig.CustomServicePhoneNumber.replacingOccurrences(of: "-", with: "")
        //linkTextStorage.underLineStyle = CTUnderlineStyle.thick
        //linkTextStorage.underLineStyle = CTUnderlineStyle.single
        
        remarkLabel = TYAttributedLabel()
        remarkLabel.delegate = self
        remarkLabel.highlightedLinkColor = CMCColor.hlightedButtonBackgroundColor
        remarkLabel.text = remarkTextString
        remarkLabel.addTextStorageArray([textStorage, linkTextStorage])
        remarkLabel.textAlignment = CTTextAlignment.center
        remarkLabel.backgroundColor = UIColor.clear
        //remarkLabel.linkColor = UIColor.clear
        
        remarkLabel.linesSpacing = 8
        self.view.addSubview(remarkLabel)
        
        remarkLabel.mas_makeConstraints { (make) in
            let _ = make?.left.equalTo()(14)
            let _ = make?.right.equalTo()(-14)
            let _ = make?.height.equalTo()(50)
            let _ = make?.top.equalTo()(self.loginButton.mas_bottom)?.setOffset(14)
        }
        
        remarkLabel.isHidden = true
    }
    
    func invalidateTime() {
        self.verifyCodeButton.isEnabled = true
        verifyCodeTime?.invalidate()
        verifyCodeTime = nil
        
        self.verifyCodeButton.mas_updateConstraints { (make) in
            let _ = make?.width.equalTo()(81)
        }
        
        self.view.spring(animations: {
            [weak self] (Void) in
            self?.verifyCodeButton.layoutIfNeeded()
        })
    }
    
    func startDownCount() {
        var totalCount: Int = 60
        //self.verifyCodeButton.isEnabled = false
        verifyCodeTime = Timer.runThisEvery(seconds: 1, handler: {
            [weak self] (time) in
            
            self?.verifyCodeButton.setTitle("\(totalCount)秒后重新获取", for: UIControlState.disabled)
            if totalCount <= 0 {
                self?.invalidateTime()
            }
            
            totalCount -= 1
        })
        
        self.verifyCodeButton.mas_updateConstraints { (make) in
            let _ = make?.width.equalTo()(111)
        }
        
        self.view.spring(animations: {
            [weak self] (Void) in
            self?.verifyCodeButton.layoutIfNeeded()
        })
    }
    
    func verifyCodeButtonPressed(sender: UIButton?) {
        log.info("verifyCodeButtonPressed")
        self.verifyCodeButton.isEnabled = false
        self.verifyCodeButton.setTitle("获取验证码", for: UIControlState.disabled)
        
        self.presenter.getVerifyCodeFromServer(phoneNumber: self.phoneNumberTextField.text ?? "")
    }
    
    func loginButtonPressed(sender: UIButton?) {
        log.info("loginButtonPressed")
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.presenter.login(phoneNumber: self.phoneNumberTextField.text ?? "",
                                 verifyCode: self.verifyCodeTextField.text ?? "")
        }
        else {
            self.presenter.loginWidthAccount(name: self.accountNameTextField.text ?? "",
                                             pwd: self.passwordTextField.text ?? "")
        }
        

    }
}

//MARK: - Public interface
extension LoginView: LoginViewInterface {
    
    func getVerifyCodeResponse(error: CMCError?) {
        if error != nil {
            self.verifyCodeButton.isEnabled = true
        }
        else {
            self.startDownCount()
        }
    }
    
    func loginSuccess() {
        let appDelegate: AppDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showTabbarViewController()
    }
    
    func loginFailed() {
        self.loginButton.isEnabled = true
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension LoginView {
    var presenter: LoginPresenter {
        return _presenter as! LoginPresenter
    }
    var displayData: LoginDisplayData {
        return _displayData as! LoginDisplayData
    }
}

extension LoginView : TYAttributedLabelDelegate {
    
    func attributedLabel(_ attributedLabel: TYAttributedLabel!, textStorageClicked textStorage: TYTextStorageProtocol!, at point: CGPoint) {
        
        if textStorage.isKind(of: TYLinkTextStorage.classForCoder()) {
            let linkStr = (textStorage as! TYLinkTextStorage).linkData as! String
            log.info("linkStr: \(linkStr)")
            //URL(string: <#T##String#>)
            if UIApplication.shared.canOpenURL(URL(string: "tel://\(linkStr)")!) {
                UIApplication.shared.openURL(URL(string: "tel://\(linkStr)")!)
            }
        }
    }
}
