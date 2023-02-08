//
//  OrderActionTableViewCell.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/23.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class OrderActionTableViewCell: UITableViewCell {
    
    var actionButtons: [CMCActionButton] = []
    // 订单状态
    var status: Int = 0
    // 买家维权订单状态
    var support_status: Int = 0
    // 来源页面类型 0： 列表  1：订单详情 2：退款详情
    var page_type: Int = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupActionButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupActionButtons()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupActionButtons() -> Void {
        
        let screenWidth = UIScreen.main.bounds.width
        
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 49))
        bgView.backgroundColor = UIColor.white
        contentView.addSubview(bgView)
//        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0.5))
//        bgView.addSubview(lineView)
//        lineView.backgroundColor = UIColor(red: 0.8353, green: 0.8353, blue: 0.8353, alpha: 1.0)
        
        for _ in 0..<4 {
            let button = CMCActionButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 73, height: 25)))
            //button.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 30))
            bgView.addSubview(button)
            button.isHidden = true
            actionButtons.append(button)
            
            button.addTarget(self, action: #selector(OrderActionTableViewCell.SELButtonPressed(_:)),
                                    for: UIControlEvents.touchUpInside)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    var orderEntity: OrderListEntity? {
//        didSet {
//            //self.setupView()
//            self.setNeedsLayout()
//        }
//    }
    
    func setOrderStatus(status: Int, support_status: Int, page_type: Int = 0) -> Void {
        self.status = status
        self.support_status = support_status
        self.page_type = page_type
        self.setNeedsLayout()
    }
    
    var indexPath: IndexPath?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for item in actionButtons {
            item.isHidden = true
        }
        
        self.setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //
    }
    
    struct OrderActionButtonType {
        var title: String
        var isSelected: Bool
    }
    
    func setupView() {
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        /// 操作按钮
        var actionButtonTypes: [OrderActionButtonType] = []
        //  列表
        if page_type == 0 {
            switch self.status {
            case ORDER_STATUS_UNPAY:
                actionButtonTypes.append(self.createActionButton("订单详情"))
            case ORDER_STATUS_PAYED:
                actionButtonTypes.append(self.createActionButton("取消订单",isSelected: true))
                if UIScreen.main.bounds.w > 320 {
                    actionButtonTypes.append(self.createActionButton("订单详情",isSelected: true))
                }
                actionButtonTypes.append(self.createActionButton("发货"))
            case ORDER_STATUS_DELIVERED:
                actionButtonTypes.append(self.createActionButton("订单详情",isSelected: true))
            //actionButtonTypes.append(self.createActionButton("查看物流"))
            case ORDER_STATUS_SUCCESS, ORDER_STATUS_CLOSED:
                actionButtonTypes.append(self.createActionButton("订单详情"))
            case ORDER_STATUS_REFUND:
                actionButtonTypes.append(self.createActionButton("退款详情"))
            default:
                actionButtonTypes.append(self.createActionButton("订单详情"))
            }
            
            if self.support_status > 0 {
                actionButtonTypes.append(self.createActionButton("退款详情"))
            }
        }
        // 订单详情
        if page_type == 1 {
            switch self.status {
            case ORDER_STATUS_UNPAY:
                actionButtonTypes.append(self.createActionButton("联系买家"))
            case ORDER_STATUS_PAYED:
                actionButtonTypes.append(self.createActionButton("取消订单",isSelected: true))
                actionButtonTypes.append(self.createActionButton("联系买家"))
                actionButtonTypes.append(self.createActionButton("发货"))
            case ORDER_STATUS_DELIVERED:
                //actionButtonTypes.append(self.createActionButton("订单详情",isSelected: true))
                //actionButtonTypes.append(self.createActionButton("查看物流"))
                break;
            case ORDER_STATUS_SUCCESS, ORDER_STATUS_CLOSED:
                //actionButtonTypes.append(self.createActionButton("订单详情"))
                break;
            case ORDER_STATUS_REFUND:
                //actionButtonTypes.append(self.createActionButton("退款详情"))
                break;
            default:
                //actionButtonTypes.append(self.createActionButton("订单详情"))
                break;
            }
//            if self.support_status > 0 {
//                actionButtonTypes.append(self.createActionButton("退款详情"))
//            }
        }
        // 退款详情
        if page_type == 2 {
            
        }
        
        if actionButtonTypes.count > 0 {
            
            var orignX: CGFloat = 14
            let screenWidth = UIScreen.main.bounds.width
            
            for (index, item) in actionButtonTypes.reversed().enumerated() {
                
                let payButtonItem = self.actionButtons[index]
                
                payButtonItem.isHidden = false
                payButtonItem.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                
                payButtonItem.setTitle(item.title, for: UIControlState())
        
                if index == 0 {
                    payButtonItem.configButtonStatus()
                }
                else {
                    payButtonItem.configButtonStatusRevers()
                }
                
                var buttonFrame = payButtonItem.frame
                buttonFrame.origin = CGPoint(x: screenWidth - buttonFrame.width - orignX, y: 12)
                buttonFrame.origin.x = buttonFrame.origin.x < 10 ? 10 : buttonFrame.origin.x
                payButtonItem.frame = buttonFrame
            
                orignX += buttonFrame.width + 14
            }
        }
    }
    /**
     创建动作按钮
     
     - parameter title:      标题
     - parameter isSelected: 是否选中
     
     - returns: UIButton
     */
    func createActionButton(_ title: String, isSelected: Bool = false) -> OrderActionButtonType {
        return OrderActionButtonType(title: title, isSelected: isSelected)
    }
    /// 点击事件
    var buttonActionCallback:((_ indexPath: IndexPath?, _ title: String?) -> Void)?
    
    /**
     按钮事件
     
     - parameter sender:
     */
    func SELButtonPressed(_ sender: UIButton) -> Void {
        guard let callBack = self.buttonActionCallback else {
            return
        }
        callBack(self.indexPath, sender.title(for: UIControlState()))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 49)
    }

}
