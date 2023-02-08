//
//  CMCStaticCellEntity.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/26.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

struct CMCStaticCellEntity {
    var cellIdentifier: String?
    var cellHeight: CGFloat = 0
}

struct CMCStaticSectionEntity {
    var rows: [CMCStaticCellEntity]?
}
