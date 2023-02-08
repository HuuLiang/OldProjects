//
//  OrderReceiveTableViewCell.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/24.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class OrderReceiveTableViewCell: UITableViewCell {
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
