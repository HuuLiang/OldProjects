//
//  MyPresenter.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import MBProgressHUD
import EZSwiftExtensions

public struct ShopInfoKey {
    static let business_time = "business_time"
    static let logo = "logo"
    static let mobile_phone = "mobile_phone"
    static let shop_address = "shop_address"
    static let shop_id = "shop_id"
    static let shop_name = "shop_name"
    static let fqa_url = "fqa_url"
    static let chart_url = "chart_url"
}

final class MyPresenter: Presenter {
    /*
        business_time
        logo
        mobile_phone
        shop_address
        shop_id
        shop_name
        fqa_url
     */
    var shopInfo: [String : AnyObject]?
    
    func getUserShopInfo() {
        
        let _ = _view.showHUDLoadView()
        
        self.interactor.getUserShopInfoFromServer()
        
    }
    
    func responseShopInfo(result: [String : AnyObject]?, error: CMCError?) {
        if let tmpError = error {
            switch tmpError {
            case .jsonSerializedFailed, .verifyTextFieldError(_):
                _view.showErrorHUDView(errorString: "加载数据失败")
            case .responseError(let code, let message):
                if _view.checkErrorCode(code: code) {
                    _view.hidHUDView()
                }
                else {
                    _view.showErrorHUDView(errorString: message, code: code)
                }
            }
        }
        else {
            _view.hidHUDView()
            self.shopInfo = result
            view.finishedLoader()
        }
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension MyPresenter {
    var view: MyViewInterface {
        return _view as! MyViewInterface
    }
    var interactor: MyInteractor {
        return _interactor as! MyInteractor
    }
    var router: MyRouter {
        return _router as! MyRouter
    }
}
