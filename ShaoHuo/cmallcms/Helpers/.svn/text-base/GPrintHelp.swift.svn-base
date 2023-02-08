//
//  GPrintHelp.swift
//  cmallcms
//
//  Created by vicoo on 2017/6/26.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import EFQRCode
import EZSwiftExtensions
import ObjectMapper

class GPrintHelp: NSObject {
    
    var response: Bool = true
    
    static let shared: GPrintHelp = GPrintHelp()
    private override init() {
        super.init()
    }
    
    /// 是否连接了打印设备
    var isConnecting: Bool {
        get {
          return BLKWrite.instance().isConnecting()
        }
    }
    
    func printReceipt(orderDetail: OrderListEntity) {
        
        printText(text: "捎货商城", feedLines: 1, justfication: 1, charcterSize: 0)
        printText(text: "*\(UserTicketModel.sharedInstance.shop_name ?? "")*", feedLines: 1, justfication: 1, charcterSize: 0)
        printText(text: "-------------------------------", feedLines: 1, justfication: 1, charcterSize: 0)
        printText(text: "下单时间: \(orderDetail.createtime ?? "")", feedLines: 1, justfication: 0, charcterSize: 0)
        printText(text: "订单号: \(orderDetail.order_sn ?? "")", feedLines: 1, justfication: 0, charcterSize: 0)
        
        // 捎货单号
        switch orderDetail.shipping_type! {
        case ORDER_SHIPPING_TYPE_SH:
            printText(text:"捎货单号: \(orderDetail.shipping_id ?? "")", feedLines: 1, justfication: 0, charcterSize: 0)
        case ORDER_SHIPPING_TYPE_SELF:
            printText(text:"购买方式: 到店自提", feedLines: 1, justfication: 0, charcterSize: 0)
        default:
            printText(text:"其它物流: \(orderDetail.shipping_id ?? "")", feedLines: 1, justfication: 0, charcterSize: 0)
        }
        
        // 备注
        if let remark = orderDetail.remark, remark.length > 0 {
            printText(text:"备注:\(remark)", feedLines: 1, justfication: 0, charcterSize: 0)
        }
        printText(text: "------------商品信息------------", feedLines: 1, justfication: 1, charcterSize: 0)
        
        for item in orderDetail.sub_list {
            let goods_name = item.goods_name ?? ""
            let itemPrice = String(format: "%.2f",(item.price ?? 0)*0.01)
            
            var sku_text: String = ""
            if let tmp_sku_text = item.sku_text, tmp_sku_text.length > 0 {
                
                sku_text = " \(tmp_sku_text.replacingOccurrences(of: ";", with: " "))"
                sku_text = " \(tmp_sku_text.replacingOccurrences(of: ":", with: " "))"
                
                printText(text: "\(goods_name) - (\(sku_text))", feedLines: 1, justfication: 0, charcterSize: 0)
            }
            else {
                printText(text: "\(goods_name)", feedLines: 1, justfication: 0, charcterSize: 0)
            }
            
            printText(text: "X\(item.goods_number ?? 0)   \(itemPrice)", feedLines: 1, justfication: 2, charcterSize: 0)
        }
        
        printText(text: "------------其它费用------------", feedLines: 1, justfication: 1, charcterSize: 0)
        
        // 配送费
        let shipping_fee =  orderDetail.shipping_fee ?? 0
        let bonus_amount = orderDetail.bonus_amount ?? 0
        let amount = orderDetail.amout ?? 0
        
        printText(text: "配送费用:        \(String(format: "￥%.2f",shipping_fee * 0.01))", feedLines: 1, justfication: 0, charcterSize: 0)
        //printText(text: "", feedLines: 1, justfication: 2, charcterSize: 0)
        
        printText(text: "优    惠:        \(String(format: "￥%.2f",bonus_amount * 0.01))", feedLines: 1, justfication: 0, charcterSize: 0)
        //printText(text: "\(String(format: "￥%.2f",bonus_amount * 0.01))", feedLines: 1, justfication: 2, charcterSize: 0)
        
        
        printText(text: "-------------------------------", feedLines: 2, justfication: 1, charcterSize: 0)
        
        printText(text: "合    计:        \(String(format: "￥%.2f",(amount+shipping_fee-bonus_amount) * 0.01))", feedLines: 1, justfication: 0, charcterSize: 0)
        //printText(text: "\(String(format: "￥%.2f",(amount+shipping_fee-bonus_amount) * 0.01))", feedLines: 1, justfication: 2, charcterSize: 0)
        
        printText(text: "-------------------------------", feedLines: 2, justfication: 1, charcterSize: 0)
        
        // 地址
        let province_name = orderDetail.province_name ?? ""
        let city_name = orderDetail.city_name ?? ""
        let district_name = orderDetail.district_name ?? ""
        let address = orderDetail.address ?? ""
        
        
        switch orderDetail.shipping_type! {
        case ORDER_SHIPPING_TYPE_SH:
            printText(text: "\(province_name)\(city_name)\(district_name)\(address)", feedLines: 2, justfication: 0, charcterSize: 0x22)
        case ORDER_SHIPPING_TYPE_SELF:
            printText(text: "\(orderDetail.self_shipping_name ?? "") \(orderDetail.self_shipping_address ?? "")", feedLines: 2, justfication: 0, charcterSize: 0x22)
            
        default:
            printText(text: "\(province_name)\(city_name)\(district_name)\(address)", feedLines: 2, justfication: 0, charcterSize: 0x22)
        }
        // 收件人
        printText(text: orderDetail.consignee ?? "", feedLines: 2, justfication: 0, charcterSize: 0)
        // 手机号
        printText(text: orderDetail.mobile ?? "", feedLines: 2, justfication: 0, charcterSize: 0)
        
        printQrcode(qrurl: orderDetail.qr_url ?? "")

    }
    /// 打印小票
    ///
    /// - Parameter orderDetail: 订单详情
    func printReceipt(orderDetail: OrderDetailItemEntity) {
        
        printText(text: "捎货商城", feedLines: 1, justfication: 1, charcterSize: 0)
        printText(text: "*\(UserTicketModel.sharedInstance.shop_name ?? "")*", feedLines: 1, justfication: 1, charcterSize: 0)
        printText(text: "-------------------------------", feedLines: 1, justfication: 1, charcterSize: 0)
        printText(text: "下单时间: \(orderDetail.createtime ?? "")", feedLines: 1, justfication: 0, charcterSize: 0)
        printText(text: "订单号: \(orderDetail.order_sn ?? "")", feedLines: 1, justfication: 0, charcterSize: 0)
        
        // 捎货单号
        switch orderDetail.shipping_type! {
        case ORDER_SHIPPING_TYPE_SH:
            printText(text:"捎货单号: \(orderDetail.shipping_id ?? "")", feedLines: 1, justfication: 0, charcterSize: 0)
        case ORDER_SHIPPING_TYPE_SELF:
            printText(text:"购买方式: 到店自提", feedLines: 1, justfication: 0, charcterSize: 0)
        default:
            printText(text:"其它物流: \(orderDetail.shipping_id ?? "")", feedLines: 1, justfication: 0, charcterSize: 0)
        }
        
        // 备注
        if let remark = orderDetail.remark, remark.length > 0 {
            printText(text:"备注:\(remark)", feedLines: 1, justfication: 0, charcterSize: 0)
        }
        printText(text: "------------商品信息------------", feedLines: 1, justfication: 1, charcterSize: 0)
        
        for item in orderDetail.sub_list! {
            let goods_name = item.goods_name ?? ""
            let itemPrice = String(format: "%.2f",(item.price ?? 0)*0.01)
            
            var sku_text: String = ""
            if let tmp_sku_text = item.sku_text, tmp_sku_text.length > 0 {
                
                sku_text = " \(tmp_sku_text.replacingOccurrences(of: ";", with: " "))"
                sku_text = " \(tmp_sku_text.replacingOccurrences(of: ":", with: " "))"
                
                printText(text: "\(goods_name) - (\(sku_text))", feedLines: 1, justfication: 0, charcterSize: 0)
            }
            else {
                printText(text: "\(goods_name)", feedLines: 1, justfication: 0, charcterSize: 0)
            }
            
            printText(text: "X\(item.goods_number ?? 0)   \(itemPrice)", feedLines: 1, justfication: 2, charcterSize: 0)
        }
        
        printText(text: "------------其它费用------------", feedLines: 1, justfication: 1, charcterSize: 0)
        
        // 配送费
        let shipping_fee =  orderDetail.shipping_fee ?? 0
        let bonus_amount = orderDetail.bonus_amount ?? 0
        let amount = orderDetail.amout ?? 0
        
        printText(text: "配送费用:        \(String(format: "￥%.2f",shipping_fee * 0.01))", feedLines: 1, justfication: 0, charcterSize: 0)
        //printText(text: "", feedLines: 1, justfication: 2, charcterSize: 0)
        
        printText(text: "优    惠:        \(String(format: "￥%.2f",bonus_amount * 0.01))", feedLines: 1, justfication: 0, charcterSize: 0)
        //printText(text: "\(String(format: "￥%.2f",bonus_amount * 0.01))", feedLines: 1, justfication: 2, charcterSize: 0)
        
        
        printText(text: "-------------------------------", feedLines: 2, justfication: 1, charcterSize: 0)
        
        printText(text: "合    计:        \(String(format: "￥%.2f",(amount+shipping_fee-bonus_amount) * 0.01))", feedLines: 1, justfication: 0, charcterSize: 0)
        //printText(text: "\(String(format: "￥%.2f",(amount+shipping_fee-bonus_amount) * 0.01))", feedLines: 1, justfication: 2, charcterSize: 0)
        
        printText(text: "-------------------------------", feedLines: 2, justfication: 1, charcterSize: 0)
        
        // 地址
        let province_name = orderDetail.province_name ?? ""
        let city_name = orderDetail.city_name ?? ""
        let district_name = orderDetail.district_name ?? ""
        let address = orderDetail.address ?? ""
        
        
        switch orderDetail.shipping_type! {
        case ORDER_SHIPPING_TYPE_SH:
            printText(text: "\(province_name)\(city_name)\(district_name)\(address)", feedLines: 2, justfication: 0, charcterSize: 0x22)
        case ORDER_SHIPPING_TYPE_SELF:
            printText(text: "\(orderDetail.self_shipping_name ?? "") \(orderDetail.self_shipping_address ?? "")", feedLines: 2, justfication: 0, charcterSize: 0x22)
            
        default:
            printText(text: "\(province_name)\(city_name)\(district_name)\(address)", feedLines: 2, justfication: 0, charcterSize: 0x22)
        }
        // 收件人
        printText(text: orderDetail.consignee ?? "", feedLines: 2, justfication: 0, charcterSize: 0)
        // 手机号
        printText(text: orderDetail.mobile ?? "", feedLines: 2, justfication: 0, charcterSize: 0)
        
        printQrcode(qrurl: orderDetail.qr_url ?? "")
    }
    
    /// 打字符串
    ///
    /// - Parameters:
    ///   - text:
    ///   - feedLines:
    ///   - justfication:
    ///   - charcterSize:
    private func printText(text: String, feedLines: Int32, justfication: Int32, charcterSize: Int32) {
        
        let escCmd = EscCommand()
        escCmd.hasResponse = response
        escCmd.addInitializePrinter()
        
        escCmd.addText(text)
        escCmd.addSetJustification(justfication)
        
        //if charcterSize > 0 {
        escCmd.addSetCharcterSize(charcterSize)
        //}
        
        if feedLines > 0 {
            escCmd.addPrintAndFeedLines(feedLines)
        }
        
        
        BLKWrite.instance().writeEscData(escCmd.getCommand(), withResponse: escCmd.hasResponse)
    }
    
    private func printQrcode(qrurl: String) {
        
        // 二维码
        //http://cmall.ishaohuo.cn/shop/shop?shop_id=36
        
        //let arcodeContent = "http://cmall.ishaohuo.cn/shop/shop?shop_id=\(UserTicketModel.sharedInstance.shop_id ?? "")"
        
        let generator = EFQRCodeGenerator(content: qrurl, size: EFIntSize(width: 200, height: 200))
        generator.setMode(mode: EFQRCodeMode.grayscale)
        generator.setInputCorrectionLevel(inputCorrectionLevel: EFInputCorrectionLevel.l)
        generator.setColors(backgroundColor: CIColor.EFBlack(), foregroundColor: CIColor.EFWhite())
        
        if let tryImage = generator.generate() {
            
            let tmpImage = UIImage(cgImage: tryImage)
            
            let tmpData = tmpImage.getDataForPrint(tmpImage) //UIImagePNGRepresentation(tmpImage)
            
            
            let escCmd = EscCommand()
            escCmd.hasResponse = response
            escCmd.addInitializePrinter()
            
            escCmd.addSetJustification(1)
            
            let picwidth = tmpImage.size.width
            let picheight = tmpImage.size.height
            
            let withxL = (picwidth / 8).truncatingRemainder(dividingBy: 256)
            let withxH = (picwidth / 8) / 256
            
            let withyL = picheight.truncatingRemainder(dividingBy: 256)
            let withyH = picheight / 256
            
            escCmd.addESCBitmapwithM(48,
                                     withxL: Int32(withxL),
                                     withxH: Int32(withxH),
                                     withyL: Int32(withyL),
                                     withyH: Int32(withyH),
                                     with: tmpData)
            escCmd.addPrintMode(0x1B)
            escCmd.addPrintAndFeedLines(5)
            
            BLKWrite.instance().writeEscData(escCmd.getCommand(), withResponse: escCmd.hasResponse)
        }
    }
}
