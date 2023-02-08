//
//  OrderRefundEntity.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/26.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderRefundEntity : Mappable {
    // 退款单id
    var rl_id: String?
    // 退款单号
    var refund_sn: String?
    // 对应订单id
    var order_id: String?
    // 支付流水id
    var oc_id: String?
    // 第三方支付流水号
    var out_trade_no: String?
    // 1：退款，2：退货，目前只有退款
    var refund_type:Int?
    // 退款/退货原因，1：拍错/不喜欢，2：未按时发货，3：其他
    var refund_reason: Int?
    // 收货状态，退款均为未收货。1：未收货，2：已收货
    var delivery_status: Int?
    // 商家驳回原因
    var refuse_reason: String?
    // 第三方退款金额
    var money_paid: Double?
    // 退款到余额的金额
    var balance_paid: Double?
    // 退款总额
    var refund_amout: Double?
    // 退款方式，置位1：微信，2：支付宝，4：余额，如5表示微信+余额混合支付
    var payment:Int?
    // 买家退款备注
    var remark: String?
    // 退款单状态，1：退款申请中，2：同意申请退款，3：申请被驳回，4：关闭退款申请，5：系统关闭退款申请
    var status: Int?
    // 凭证图片1
    var proof_img1: String?
    // 凭证图片2
    var proof_img2: String?
    // 凭证图片3
    var proof_img3: String?
    // 创建时间
    var createtime: String?
    // 最后更新时间
    var lastupdtime: String?
    // 第三方支付方式，1:微信公众号，2:微信app，3:支付宝
    var sub_payment: Int?
    // 退款原因文字表述
    var refund_reason_text: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)  {
        // 退款单id
        rl_id <- map["rl_id"]
        // 退款单号
        refund_sn <- map["refund_sn"]
        // 对应订单id
        order_id <- map["order_id"]
        // 支付流水id
        oc_id <- map["oc_id"]
        // 第三方支付流水号
        out_trade_no <- map["out_trade_no"]
        // 1：退款，2：退货，目前只有退款
        refund_type <- (map["refund_type"], intTransform)
        // 退款/退货原因，1：拍错/不喜欢，2：未按时发货，3：其他
        refund_reason <- (map["refund_reason"], intTransform)
        // 收货状态，退款均为未收货。1：未收货，2：已收货
        delivery_status <- (map["delivery_status"], intTransform)
        // 商家驳回原因
        refuse_reason <- map["refuse_reason"]
        // 第三方退款金额
        money_paid <- (map["money_paid"], doubleTransform)
        // 退款到余额的金额
        balance_paid <- (map["balance_paid"], doubleTransform)
        // 退款总额
        refund_amout <- (map["refund_amout"], doubleTransform)
        // 退款方式，置位1：微信，2：支付宝，4：余额，如5表示微信+余额混合支付
        payment <- (map["payment"], intTransform)
        // 买家退款备注
        remark <- map["remark"]
        // 退款单状态，1：退款申请中，2：同意申请退款，3：申请被驳回，4：关闭退款申请，5：系统关闭退款申请
        status <- (map["status"], intTransform)
        // 凭证图片1
        proof_img1 <- map["proof_img1"]
        // 凭证图片2
        proof_img2 <- map["proof_img2"]
        // 凭证图片3
        proof_img3 <- map["proof_img3"]
        // 创建时间
        createtime <- map["createtime"]
        // 最后更新时间
        lastupdtime <- map["lastupdtime"]
        // 第三方支付方式，1:微信公众号，2:微信app，3:支付宝
        sub_payment <- (map["sub_payment"], intTransform)
        // 退款原因文字表述
        refund_reason_text <- map["refund_reason_text"]
    }
}
