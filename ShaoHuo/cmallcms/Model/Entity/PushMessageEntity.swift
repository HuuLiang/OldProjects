//
//  PushMessageEntity.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/27.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import ObjectMapper

class PushMessageEntity : Mappable {

    /// 消息id
    var pn_id: String?
    /// 用户id
    var ad_uid: String?
    /// 推送的消息
    var push_title: String?
    /// 推送状态 1 未推送 2 已推送
    var push_status: Int?
    /// 阅读状态 1 未读 2 已读
    var read_status: Int?
    /// 创建时间
    var create_time: String?
    /// 订单状态
    var order_status: Int?
    /// 订单id
    var order_id: String?
    /// 是否删除 1 未删除 2 已删除
    var is_del: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)  {
        pn_id <- map["pn_id"]
        ad_uid <- map["ad_uid"]
        push_title <- map["push_title"]
        push_status <- (map["push_status"], intTransform)
        read_status <- (map["read_status"], intTransform)
        create_time <- map["create_time"]
        order_status <- (map["order_status"], intTransform)
        order_id <- map["order_id"]
        is_del <- (map["is_del"], intTransform)
    }

}
