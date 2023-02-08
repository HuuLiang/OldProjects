//
//  MyInteractor.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
//import Viperit

final class MyInteractor: Interactor {
    
    func getUserShopInfoFromServer() {
    
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "user_type": UserTicketModel.sharedInstance.user_type ?? "",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? ""
        ]
        
        UserLoginModel.shared.userShopInfo(params) { (result, error) in
            self.presenter.responseShopInfo(result: result, error: error)
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension MyInteractor {
    var presenter: MyPresenter {
        return _presenter as! MyPresenter
    }
}
