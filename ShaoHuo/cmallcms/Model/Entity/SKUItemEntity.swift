//
//  SKUItemEntity.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/22.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import ObjectMapper

class SKUItemEntity: Mappable {
    //规格文字描述，使用：sub_list['sku_text']['sku_text'] ps:后面这个字段可能保存其他内容
    var sku_text: String?
    // 商品名称
    var goods_name: String?
    // 商品id
    var goods_id: String?
    // 所属订单id
    var order_id: String?
    // 商品图
    var goods_img: String?
    // 规格id组合
    var ssd_ids: String?
    // 商品价格
    var price: Double?
    // 购买数量
    var goods_number: Int?
    // 总金额
    var amout: Double?
    // 优惠金额
    var bonus_amount: Double?
    var shipping_fee: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)  {
        
        sku_text <- map["sku_text.sku_text"]
        goods_name <- map["goods_name"]
        goods_id <- map["goods_id"]
        order_id <- map["order_id"]
        goods_img <- map["goods_img"]
        ssd_ids <- map["ssd_ids"]
        price <- (map["price"], doubleTransform)
        goods_number <- (map["goods_number"], intTransform)
        amout <- (map["amout"], doubleTransform)
        bonus_amount <- (map["bonus_amount"], doubleTransform)
        shipping_fee <- (map["shipping_fee"], doubleTransform)
    }
}

