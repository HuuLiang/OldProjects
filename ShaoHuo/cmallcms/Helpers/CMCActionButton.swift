//
//  CMCActionButton.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/20.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

class CMCActionButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configButtonStatus()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configButtonStatus()
    }
    
    func configButtonStatus() {
        
        self.setBackgroundImage(UIImage(named:"icon_button_border_h"), for: UIControlState.normal)
        self.setBackgroundImage(UIImage(named:"icon_button_border"), for: UIControlState.disabled)
        self.setBackgroundImage(UIImage(named:"icon_button_border"), for: UIControlState.highlighted)
        
        self.setTitleColor(CMCColor.hlightedButtonBackgroundColor, for: UIControlState.normal)
        self.setTitleColor(CMCColor.normalButtonBackgroundColor, for: UIControlState.disabled)
        self.setTitleColor(CMCColor.normalButtonBackgroundColor, for: UIControlState.highlighted)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    func configButtonStatusRevers() {
        
        self.setBackgroundImage(UIImage(named:"icon_button_border"), for: UIControlState.normal)
        self.setBackgroundImage(UIImage(named:"icon_button_border"), for: UIControlState.disabled)
        self.setBackgroundImage(UIImage(named:"icon_button_border_h"), for: UIControlState.highlighted)
        
        self.setTitleColor(CMCColor.normalButtonBackgroundColor, for: UIControlState.normal)
        self.setTitleColor(CMCColor.normalButtonBackgroundColor, for: UIControlState.disabled)
        self.setTitleColor(CMCColor.hlightedButtonBackgroundColor, for: UIControlState.highlighted)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        
//        self.popBig()
//    }
}
