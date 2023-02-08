//
//  OrderDetailEntity.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/23.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderDetailEntity : Mappable {
    
    var order: OrderDetailItemEntity?
    var action_list: [OrderTrackItemEntity]? = []
    
    var refund: OrderRefundEntity?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)  {
        
        order <- map["order"]
        action_list <- map["action_list"]
        refund <- map["refund"]
    }
}

class OrderDetailItemEntity: Mappable {
    // 订单id
    var order_id: String?
    // 用户id
    var uid: String?
    // 店铺id
    var shop_id: String?
    // 订单号
    var order_sn: String?
    // 订单商品品种数量
    var nums: Int?
    //
    var first_kind_num: Int?
    // 商品名称
    var goods_name: String?
    var goods_img: String?
    var sku_text: String?
    var amout: Double?
    //物流类型，1：捎货物流，2：其它物流，3：自提
    var shipping_type:Int?
    var shipping_id: String?
    //物流费用
    var shipping_fee: Double?
    // 捎货物流费
    var shaohuo_shipping_fee: Double?
    // 自提点名称
    var self_shipping_name: String?
    // 自提点详细地址
    var self_shipping_address: String?
    // 自提时间
    var self_shipping_time: String?
    var express_name: String?
    // 收件省id
    var province: String?
    var province_name: String?
    // 收件城市id
    var city: String?
    var city_name: String?
    // 收件区id
    var district: String?
    var district_name: String?
    // 收件详细地址
    var address: String?
    // 收件门牌号
    var building: String?
    // 收件人
    var consignee: String?
    // 收件人电话号码
    var mobile: String?
    var receiver_lat: Double?
    var receiver_lng: Double?
    var print_count: Int?
    // 订单状态
    var status: Int?
    // 订单类型，1：云商订单，2：帮我买订单
    var type:Int?
    // 默认0为普通订单，1:云商秒杀订单,2:云商天天特价订单,3:免费试吃活动订单,4:积分商品订单,5:新人专享订单
    var sub_type: Int?
    /// 积分兑换比例
    var integral_rate: Int?
    /// 积分兑换比例
    var integral_bank_name: String?
    //退款/退货单id
    var rl_id: String?
    // 退款单状态
    var support_status: Int?
    var remark: String?
    var seller_remark: String?
    var settlementtime: String?
    var createtime: String?
    var lastupdtime: String?
    
    /// 限制支付时长 秒
    var limit_pay_time: Int?
    // 会员极别
    var member_level: Int?
    // 优惠金额
    var bonus_amount: Double?
    // 分享人的UID
    var bonus_uid: String?
    // 订单是否结算
    var is_settled: Int?
    
    var region_id:String?
    var parent_id: String?
    var username: String?
    var level: Int?
    var sort: Int?
    var is_hot: Int?
    var is_open: Int?
    // 订单状态 字符串
    var status_text: String?
    // SKU list
    var sub_list: [SKUItemEntity]? = []
    
    // 支付方式
    var payment: Int?
    // 支付时间
    var pay_time: String?
    // 支付方式字符串
    var payment_text: String?
    
    var qr_url: String?
    
    //var print_count: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)  {
        // 订单id
        order_id <- map["order_id"]
        // 用户id
        uid <- map["uid"]
        // 店铺id
        shop_id <- map["shop_id"]
        // 订单号
        order_sn <- map["order_sn"]
        // 订单商品品种数量
        nums <- (map["nums"], intTransform)
        //
        first_kind_num <- (map["first_kind_num"], intTransform)
        // 商品名称
        goods_name <- map["goods_name"]
        goods_img <- map["goods_img"]
        sku_text <- map["sku_text.sku_text"]
        amout <- (map["amout"], doubleTransform)
        //物流类型，1：捎货物流，2：其它物流，3：自提
        shipping_type <- (map["shipping_type"], intTransform)
        shipping_id <- map["shipping_id"]
        //物流费用
        shipping_fee <- (map["shipping_fee"], doubleTransform)
        // 捎货物流费
        shaohuo_shipping_fee <- (map["shaohuo_shipping_fee"], doubleTransform)
        // 自提点名称
        self_shipping_name <- map["self_shipping_name"]
        // 自提点详细地址
        self_shipping_address <- map["self_shipping_address"]
        // 自提时间
        self_shipping_time <- map["self_shipping_time"]
        express_name <- map["express_name"]
        // 收件省id
        province <- map["province"]
        province_name <- map["province_name"]
        // 收件城市id
        city <- map["city"]
        city_name <- map["city_name"]
        // 收件区id
        district <- map["district"]
        district_name <- map["district_name"]
        // 收件详细地址
        address <- map["address"]
        // 收件门牌号
        building <- map["building"]
        // 收件人
        consignee <- map["consignee"]
        // 收件人电话号码
        mobile <- map["mobile"]
        receiver_lat <- (map["receiver_lat"], doubleTransform)
        receiver_lng <- (map["receiver_lng"], doubleTransform)
        print_count <- (map["print_count"], intTransform)
        // 订单状态
        status <- (map["status"], intTransform)
        // 订单类型，1：云商订单，2：帮我买订单
        type <- (map["type"], intTransform)
        // 默认0为普通订单，1:云商秒杀订单,2:云商天天特价订单,3:免费试吃活动订单,4:积分商品订单,5:新人专享订单
        sub_type <- (map["sub_type"], intTransform)
        /// 积分兑换比例
        integral_rate <- (map["integral_rate"], intTransform)
        /// 积分兑换比例
        integral_bank_name <- map["integral_bank_name"]
        //退款/退货单id
        rl_id <- map["rl_id"]
        // 售后状态
        support_status <- (map["support_status"], intTransform)
        remark <- map["remark"]
        seller_remark <- map["seller_remark"]
        settlementtime <- map["settlementtime"]
        createtime <- map["createtime"]
        lastupdtime <- map["lastupdtime"]
        
        /// 限制支付时长 秒
        limit_pay_time <- (map["limit_pay_time"], intTransform)
        // 会员极别
        member_level <- (map["member_level"], intTransform)
        // 优惠金额
        bonus_amount <- (map["bonus_amount"], doubleTransform)
        // 分享人的UID
        bonus_uid <- map["bonus_uid"]
        // 订单是否结算
        is_settled <- (map["is_settled"], intTransform)
        
        region_id <- map["region_id"]
        parent_id <- map["parent_id"]
        username <- map["username"]
        level <- (map["level"], intTransform)
        sort <- (map["sort"], intTransform)
        is_hot <- (map["is_hot"], intTransform)
        is_open <- (map["is_open"], intTransform)
        // 订单状态 字符串
        status_text <- map["status_text"]
        // SKU list
        sub_list <- map["sub_list"]
        
        // 支付方式
        payment <- map["payment"]
        // 支付时间
        pay_time <- map["pay_time"]
        // 支付方式字符串
        payment_text <- map["payment_text"]
        
        qr_url <- map["qr_url"]
    }
}
