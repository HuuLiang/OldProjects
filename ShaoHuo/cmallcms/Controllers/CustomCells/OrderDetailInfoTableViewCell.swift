//
//  OrderDetailInfoTableViewCell.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/25.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class OrderDetailInfoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
    }
    
    func setShowTitles(titles: [String], values: [String]) -> Void {
        
        var lastView: UIView? = nil
        
        for tmpView in self.contentView.subviews {
            tmpView.removeFromSuperview()
        }
        
        for i in 0..<titles.count {
            
            if i == (titles.count - 1) {
                let _ = self.createLineLabel(title: titles[i],subTitle: values[i], lastView: lastView, isLast: true)
            }
            else {
                lastView = self.createLineLabel(title: titles[i],subTitle: values[i], lastView: lastView)
            }
        }
    }
    
    func createLineLabel(title: String, subTitle: String, lastView: UIView?, isLast: Bool = false) -> UIView {
        
        let leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 17))
        leftLabel.text = title + ":"
        self.contentView.addSubview(leftLabel)
        leftLabel.font = UIFont.systemFont(ofSize: 15)
        leftLabel.textColor = UIColor(hexString: "9C9C9C")
        
        
        let rightLabelRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 164, height: 50)
        let rightLabel = UILabel(frame: rightLabelRect)
        if subTitle.length <= 0 {
            rightLabel.text = "  "
        }
        else {
            
            rightLabel.text = subTitle
        }
        rightLabel.textColor = UIColor(hexString: "333333")
        rightLabel.font = UIFont.systemFont(ofSize: 15)
        rightLabel.numberOfLines = 0
        self.contentView.addSubview(rightLabel)
        
        var rightLabelContentSizeHeight = rightLabel.sizeThatFits(CGSize(width:UIScreen.main.bounds.width - 163, height: 1000)).height + 2
        if rightLabelContentSizeHeight <= 17 {
            rightLabelContentSizeHeight = 17
        }
        
        //log.info("\(title) contentHeight: \(rightLabelContentSizeHeight)")
        
        let leftWidth = leftLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: 320, height: 17), limitedToNumberOfLines: 1).size.width + 5
        let finalLeftLabelWidth = max(leftWidth, 70)
        //finalLeftLabelWidth = max(100, finalLeftLabelWidth)
        
        if isLast == true {
            
            leftLabel.mas_makeConstraints { (make) in
                let _ = make?.left.equalTo()(14)
                let _ = make?.height.equalTo()(17)
                let _ = make?.width.equalTo()(finalLeftLabelWidth)
                let _ = make?.top.equalTo()(rightLabel.mas_top)
            }
            
            rightLabel.mas_makeConstraints({ (make) in
                
                let _ = make?.left.equalTo()(149)
                let _ = make?.right.equalTo()(-14)
                let _ = make?.top.equalTo()(lastView!.mas_bottom)?.setOffset(14)
                let _ = make?.bottom.equalTo()(self.contentView.mas_bottom)?.setOffset(-14)
                //let _ = make?.height.greaterThanOrEqualTo()(17)?.with().priorityHigh()
                //let _ = make?.height.mas_equalTo()(rightLabelContentSizeHeight)
            })
        }
        else {
            leftLabel.mas_makeConstraints { (make) in
                let _ = make?.left.equalTo()(14)
                let _ = make?.height.equalTo()(17)
                let _ = make?.width.equalTo()(finalLeftLabelWidth)
                let _ = make?.top.equalTo()(rightLabel.mas_top)
            }
            
            if lastView == nil {
                rightLabel.mas_makeConstraints({ (make) in
                    //let _ = make?.left.equalTo()(leftLabel.mas_right)?.setOffset(49)
                    let _ = make?.left.equalTo()(149)
                    let _ = make?.right.equalTo()(-14)
                    let _ = make?.top.equalTo()(14)
                    let _ = make?.height.mas_equalTo()(rightLabelContentSizeHeight)
                })
            }
            else {
                rightLabel.mas_makeConstraints({ (make) in
                    //let _ = make?.left.equalTo()(leftLabel.mas_right)?.setOffset(49)
                    let _ = make?.left.equalTo()(149)
                    let _ = make?.right.equalTo()(-14)
                    let _ = make?.top.equalTo()(lastView!.mas_bottom)?.setOffset(14)
                    //let _ = make?.height.greaterThanOrEqualTo()(17)?.with().priorityHigh()
                    let _ = make?.height.mas_equalTo()(rightLabelContentSizeHeight)
                })
            }
            
        }
        
        return rightLabel
    }


}
/*
extension OrderDetailInfoTableViewCell : TYAttributedLabelDelegate {
    func attributedLabel(_ attributedLabel: TYAttributedLabel!, textStorageClicked textStorage: TYTextStorageProtocol!, at point: CGPoint) {
        
        if textStorage.isKind(of: TYLinkTextStorage.classForCoder()) {
            let linkStr = (textStorage as! TYLinkTextStorage).linkData as! String
            log.info("linkStr: \(linkStr)")
            //URL(string: <#T##String#>)
            if UIApplication.shared.canOpenURL(URL(string: "tel://\(linkStr)")!) {
                UIApplication.shared.openURL(URL(string: "tel://\(linkStr)")!)
            }
        }
    }

}
 */
