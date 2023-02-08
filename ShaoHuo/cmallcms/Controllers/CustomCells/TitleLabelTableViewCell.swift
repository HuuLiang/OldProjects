//
//  TitleLabelTableViewCell.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/23.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class TitleLabelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configLabtlText(leftLabelAttributeString: NSAttributedString, rightLabelAttributeString: NSAttributedString) -> Void {
        self.leftLabel.attributedText = leftLabelAttributeString
        self.rightLabel.attributedText = rightLabelAttributeString
    }
}
