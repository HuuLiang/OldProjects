//
//  MessagePresenter.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import MBProgressHUD
import ObjectMapper
import AFNetworking
import JDStatusBarNotification
import EZSwiftExtensions

final class MessagePresenter: Presenter {
    
    lazy var pageListParam: PageListModel = {
        return PageListModel(from: "0", last: "0", size: 20, lastPage: false)
    }()
    
    var messageList: [PushMessageEntity] = []
    
    func getMessageList(isReload: Bool = false) -> Void {
        
        if isReload {
            let _ = _view.showHUDLoadView()
            pageListParam.last = "0"
            pageListParam.from = "0"
            messageList.removeAll()
            //view.finishedLoad()
        }
        let _ = self.interactor.getMessageListFormServer(pageListParam: pageListParam)
    }
    
    func readMessage(index: Int) -> Void {
        
        let item = self.messageList[index]
        item.read_status = 2
//        let _ = _view.showHUDLoadView()
        let _ = self.interactor.readNewsInfo(type: 1, pn_id: item.pn_id ?? "")
    }
    
    func deleteMessage(index: Int) -> Void {
        let item = self.messageList[index]
        let _ = self.interactor.delMessage(pn_id: item.pn_id ?? "")
        self.messageList.remove(at: index)
        //view.finishedLoad()
        
        if item.read_status == 1 {
            decreaseBadgeValue()
        }
    }
    
    func responseMessageList(reslut: [String : AnyObject]?, error: CMCError?) -> Void {
        
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
            
            if reslut == nil {
                view.finishedLoad()
            }
            else {
                let listJSONArray = reslut?["list"] as! [[String: AnyObject]]
                let mapper = Mapper<PushMessageEntity>()
                let tmpOrderList: [PushMessageEntity] = mapper.mapArray(JSONArray: listJSONArray)!
                
                if tmpOrderList.count <= 0 {
                    view.noMoreData()
                }
                else {
                    self.messageList.append(contentsOf: tmpOrderList)
                    let lastItem = self.messageList.last
                    self.pageListParam.from = lastItem?.pn_id ?? ""
                    self.pageListParam.last = ""
                    view.finishedLoad()
                }
            }
        }
    }
    
    func responseReadMessage(reslut: [String : AnyObject]?, error: CMCError?) -> Void {
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
            decreaseBadgeValue()
            view.finishedLoad()
        }
    }
    
    func responseDelMessage(reslut: [String : AnyObject]?, error: CMCError?) -> Void {
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
            view.finishedLoad()
        }
    }
    
    func decreaseBadgeValue() {
        
        if let badgeValue = _view.tabBarItem.badgeValue?.toInt() {
            let tmpBadgeValue = badgeValue - 1
            if tmpBadgeValue > 0 {
                _view.tabBarItem.badgeValue = "\(tmpBadgeValue)"
            }
            else {
                _view.tabBarItem.badgeValue = nil
            }
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension MessagePresenter {
    var view: MessageViewInterface {
        return _view as! MessageViewInterface
    }
    var interactor: MessageInteractor {
        return _interactor as! MessageInteractor
    }
    var router: MessageRouter {
        return _router as! MessageRouter
    }
}
