//
//  OrderListEntity.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/22.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderListEntity: Mappable {
    //订单id
    var order_id: String?
    var shop_id: String?
    // 用户id
    var uid: String?
    // 下单人姓名
    var username: String?
    // 订单号
    var order_sn: String?
    // 订单商品品种数量
    var nums:Int?
    // 商品总金额
    var amout:Double?
    // 1：捎货物流，2：其它物流，3：自提
    var shipping_type:Int?
    
    var shipping_id: String?
    // 物流费用
    var shipping_fee: Double?
    
    /// 优惠金额
    var bonus_amount: Double?
    // 自提点名称
    var self_shipping_name: String?
    // 自提点详细地址
    var self_shipping_address: String?
    // 自提时间
    var self_shipping_time: String?
    // 收件省id
    var province: String?
    // 收件城市id
    var city: String?
    // 收件区id
    var district: String?
    // 收件详细地址
    var address: String?
    // 收件门牌号
    var building: String?
    // 收件人
    var consignee: String?
    // 收件人电话号码
    var mobile: String?
    // 订单状态
    var status:Int?
    // 订单类型，1：云商订单，2：帮我买订单
    var type:Int?
    // 默认0为普通订单，1:云商秒杀订单,2:云商天天特价订单,3:免费试吃活动订单,4:积分商品订单,5:新人专享订单
    var sub_type:Int?
    // 退款/退货单id
    var rl_id: String?
    // 退款单状态
    var support_status: Int?
    var remark: String?
    // 订单商家备注
    var seller_remark: String?
    var createtime: String?
    var lastupdtime: String?
    // 收件省名称
    var province_name: String?
    // 收件市名称
    var city_name: String?
    // 收件区名称
    var district_name: String?
    // 订单状态文字描述
    var status_text: String?
    // 订单商品详情
    var sub_list: [SKUItemEntity] = []
    
    var qr_url: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)  {
        
        //订单id
        order_id <- map["order_id"]
        shop_id <- map["shop_id"]
        // 用户id
        uid <- map["uid"]
        // 订单号
        order_sn <- map["order_sn"]
        
        nums <- (map["nums"], intTransform)
        
        amout <- (map["amout"], doubleTransform)
        
        bonus_amount <- (map["bonus_amount"], doubleTransform)
        // 1：捎货物流，2：其它物流，3：自提
        shipping_type <- (map["shipping_type"], intTransform)
        shipping_fee <- (map["shipping_fee"], doubleTransform)
        // 自提点名称
        self_shipping_name <- map["self_shipping_name"]
        // 自提点详细地址
        self_shipping_address <- map["self_shipping_address"]
        // 自提时间
        self_shipping_time <- map["self_shipping_time"]
        // 收件省id
        province <- map["province"]
        // 收件城市id
        city <- map["city"]
        // 收件区id
        district <- map["district"]
        // 收件详细地址
        address <- map["address"]
        // 收件门牌号
        building <- map["building"]
        // 收件人
        consignee <- map["consignee"]
        // 收件人电话号码
        mobile <- map["mobile"]
        // 订单状态
        status <- (map["status"], intTransform)
        // 订单类型，1：云商订单，2：帮我买订单
        type <- (map["type"], intTransform)
        // 默认0为普通订单，1:云商秒杀订单,2:云商天天特价订单,3:免费试吃活动订单,4:积分商品订单,5:新人专享订单
        sub_type <- (map["sub_type"], intTransform)
        // 退款/退货单id
        rl_id <- map["rl_id"]
        // 售后状态
        support_status <- (map["support_status"], intTransform)
        remark <- map["remark"]
        // 订单商家备注
        seller_remark <- map["seller_remark"]
        createtime <- map["createtime"]
        lastupdtime <- map["lastupdtime"]
        // 收件省名称
        province_name <- map["province_name"]
        // 收件市名称
        city_name <- map["city_name"]
        // 收件区名称
        district_name <- map["district_name"]
        // 订单状态文字描述
        status_text <- map["status_text"]
        // 订单商品详情
        sub_list <- map["sub_list"]
        // 下单人姓名
        username <- map["username"]
        
        shipping_id <- map["shipping_id"]
        //shipping_id
        
        qr_url <- map["qr_url"]
    }
}

