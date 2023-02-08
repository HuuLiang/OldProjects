//
//  RefundActionTableViewCell.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/26.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class RefundActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var refuseButton: CMCActionButton!
    
    @IBOutlet weak var agreeButton: CMCActionButton!
    
    @IBOutlet weak var agreeButtonTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        refuseButton.configButtonStatus()
        agreeButton.configButtonStatusRevers()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// 设置退款状态
    ///
    /// - Parameters:
    ///   - support_status: SUPPORT_STATUS
    ///   - refund_status:
    func setOrderStatus(support_status: Int, refund_status: Int) -> Void {
        
        if support_status == SUPPORT_STATUS_REFUND_REFUSED {
            self.refuseButton.isHidden = true
            agreeButtonTrailingConstraint.constant = 14
            agreeButton.configButtonStatus()
        }
        else {
            self.refuseButton.isHidden = false
            agreeButtonTrailingConstraint.constant = 100
            
            refuseButton.configButtonStatus()
            agreeButton.configButtonStatusRevers()
        }
    }
}
