//
//  StaticTableViewRow.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/24.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit

open class StaticTableViewRow: StaticTableViewNode {
    
    open var cell: UITableViewCell?
    
    open var height: CGFloat?
    open var estimatedHeight: CGFloat?
    
    open var editActions: [UITableViewRowAction]?
    
    open var didSelectHandler: ((StaticTableViewRow, UITableView, IndexPath) -> Void)?
    open var didDeselectHandler: ((StaticTableViewRow, UITableView, IndexPath) -> Void)?
    
    open var didTapAccessoryButtonHandler: ((StaticTableViewRow, UITableView, IndexPath) -> Void)?
    
    open var heightHandler: ((StaticTableViewRow, UITableView, IndexPath) -> CGFloat)?
    
    open var editActionsHandler: ((StaticTableViewRow, UITableView, IndexPath) -> [UITableViewRowAction]?)?
    
    open var dequeueCellHandler: ((StaticTableViewRow, UITableView, IndexPath) -> UITableViewCell)?
    
    public convenience init(object: AnyObject?) {
        self.init()
        self.object = object
    }
    
    public convenience init(cell: UITableViewCell) {
        self.init()
        self.cell = cell
    }
}

public func ==(lhs: StaticTableViewRow, rhs: StaticTableViewRow) -> Bool {
    if let lhsCell = lhs.cell, let rhsCell = rhs.cell , lhsCell == rhsCell {
        return true
    } else {
        return lhs === rhs
    }
}
