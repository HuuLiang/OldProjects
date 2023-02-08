//
//  ShopInfoEntity.swift
//  cmallcms
//  店铺列表
//  Created by vicoo on 2017/6/28.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation

import ObjectMapper

class ShopInfoListEntity : Mappable {
    
    var list: [ShopItemEntity] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)  {
        list <- map["list"]
    }
}

class ShopItemEntity: Mappable {
    
    var shop_id: String?
    var shop_name: String?
    var ad_uid: String?
    var alias: String?
    var token: String?
    var user_type: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)  {
        shop_id <- map["shop_id"]
        shop_name <- map["shop_name"]
        ad_uid <- map["ad_uid"]
        alias <- map["alias"]
        token <- map["token"]
        user_type <- map["user_type"]
    }
}
