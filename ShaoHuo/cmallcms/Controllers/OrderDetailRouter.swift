//
//  OrderDetailRouter.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
//import Viperit

final class OrderDetailRouter: Router {
    
    
    override func show(from: UIViewController, embedInNavController: Bool, setupData: Any?) {
        
        if let data = setupData {
            presenter.setupView(data: data)
        }
        (from as! UINavigationController).pushViewController(_view, animated: true)
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OrderDetailRouter {
    var presenter: OrderDetailPresenter {
        return _presenter as! OrderDetailPresenter
    }
}
