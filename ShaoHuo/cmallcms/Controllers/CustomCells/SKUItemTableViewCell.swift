//
//  SKUItemTableViewCell.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/23.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class SKUItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var skuItemImageView: UIImageView!
    
    @IBOutlet weak var skuItemNameLabel: UILabel!
    
    @IBOutlet weak var skuItemCountLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var skuItemEntity: SKUItemEntity? {
        didSet {
            
            if let goods_img = skuItemEntity?.goods_img {
                var tmpGoodsImg: String = goods_img
                if goods_img.hasPrefix("http://") {
                    tmpGoodsImg = goods_img.replacingOccurrences(of: "http://", with: "https://")
                }
                self.skuItemImageView.sd_setImage(with: URL(string: tmpGoodsImg))
            }
            
            var sku_text: String = ""
            if let tmp_sku_text = skuItemEntity?.sku_text, tmp_sku_text.length > 0 {
                sku_text = " \(tmp_sku_text.replacingOccurrences(of: "；", with: ""))"
            }
            self.skuItemNameLabel.text = "\(skuItemEntity?.goods_name ?? "") \(sku_text)"
            
            
            self.skuItemCountLabel.text = "x\((skuItemEntity?.goods_number ?? 0))"
            
            let totalAmount = skuItemEntity!.price! * 0.01
            self.priceLabel.text = String(format: "￥%.2f", totalAmount)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 113)
    }
}
