//
//  MessageInteractor.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/18.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
//import Viperit

final class MessageInteractor: Interactor {
    
    func getMessageListFormServer(pageListParam: PageListModel) -> URLSessionDataTask? {
        
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "size": "\(pageListParam.size)",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "from": pageListParam.from,
            "last": pageListParam.last
        ]
        
        return MessageListModel.shared.messageList(params) { (result, error) in
            self.presenter.responseMessageList(reslut: result, error: error)
        }
    }
    
    /// 消息已读
    ///
    /// - Parameters:
    ///   - type: 1 读一条消息 2 读所有消息
    ///   - pn_id: 消息id 当type为1的时候 pn_id 必填
    /// - Returns:
    func readNewsInfo(type: Int, pn_id: String) -> URLSessionDataTask? {
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "type": "\(type)",
            "pn_id": pn_id
        ]
        
        return MessageListModel.shared.messageReadStatus(params, complete: { (result, error) in
            self.presenter.responseReadMessage(reslut: result, error: error)
        })
    }
    
    func delMessage(pn_id: String) -> URLSessionDataTask? {
        
        let params = [
            "ad_uid": UserTicketModel.sharedInstance.uid ?? "",
            "token": UserTicketModel.sharedInstance.token ?? "",
            "shop_id": UserTicketModel.sharedInstance.shop_id ?? "",
            "pn_id": pn_id
        ]
        
        return MessageListModel.shared.messageDelete(params, complete: { (result, error) in
            self.presenter.responseDelMessage(reslut: result, error: error)
        })
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension MessageInteractor {
    var presenter: MessagePresenter {
        return _presenter as! MessagePresenter
    }
}
