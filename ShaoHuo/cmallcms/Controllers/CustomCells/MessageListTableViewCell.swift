//
//  MessageListTableViewCell.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/27.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class MessageListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var msgTypeImageView: UIImageView!
    
    @IBOutlet weak var newMsgImageView: UIImageView!
    
    @IBOutlet weak var msgTypeLabel: UILabel!
    
    @IBOutlet weak var msgTimeLabel: UILabel!
    
    @IBOutlet weak var msgContentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var msgItemEntity: PushMessageEntity? {
        didSet {
            self.newMsgImageView.isHidden = msgItemEntity?.read_status == 2
            self.msgContentLabel.text = msgItemEntity?.push_title ?? ""
            
            if let create_time = msgItemEntity?.create_time {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let newDate = formatter.date(from: create_time)
                self.msgTimeLabel.text = newDate?.timeAgo(since: Date(), numericDates: true, numericTimes: false)
            }
        }
    }
}
