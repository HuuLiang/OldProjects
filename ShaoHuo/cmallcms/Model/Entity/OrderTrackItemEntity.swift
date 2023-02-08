//
//  OrderTrackItemEntity.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/23.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderTrackItemEntity : Mappable {
    
    var oa_id: String?
    // 订单id
    var o_id: String?
    // 订单状态
    var status: Int?
    // 后台操作人id
    var au_id: String?
    // 操作时间
    var createtime: String?
    // 操作时间文字表述，如:发货时间
    var time_text: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)  {
        
        oa_id <- map["oa_id"]
        o_id <- map["o_id"]
        status <- (map["status"], intTransform)
        au_id <- map["au_id"]
        createtime <- map["createtime"]
        time_text <- map["time_text"]
        
    }
}
