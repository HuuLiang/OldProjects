//
//  UINavigationItemExtensions.swift
//  LTBUS
//
//  Created by MAYING on 2017/5/28.
//  Copyright © 2017年 lchenc3. All rights reserved.
//

import UIKit

public extension UINavigationItem {
    func lt_setLeftBarButtonItem(leftBarButtonItem: UIBarButtonItem) -> Void {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        flexSpace.width = -10
        self.leftBarButtonItems = [flexSpace, leftBarButtonItem]
    }
    
    func lt_setRightBarButtonItem(rightBarButtonItem: UIBarButtonItem) -> Void {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        flexSpace.width = -10
        self.rightBarButtonItems = [flexSpace,rightBarButtonItem]
    }
}
