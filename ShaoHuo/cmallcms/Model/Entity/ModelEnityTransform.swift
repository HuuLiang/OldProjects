//
//  ModelEnityTransform.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/22.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import ObjectMapper

let timeStringTransform = TransformOf<String, String>(fromJSON: { (value: String?) -> String? in
    // transform value from String? to Int?
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let newDate = dateFormatter.date(from: value!)
    
    if newDate == nil {
        return ""
    }
    
    let dateFormatter2 = DateFormatter()
    dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let newDateString = dateFormatter2.string(from: newDate!)
    
    return newDateString
    
    
}, toJSON: { (value: String?) -> String? in
    // transform value from Int? to String?
    //        if let value = value {
    //            return value
    //        }
    //        return nil
    return value
})

let doubleTransform = TransformOf<Double, String>(fromJSON: { (value: String?) -> Double? in
    
    return value?.toDouble() ?? 0
    
}, toJSON: { (value: Double?) -> String? in
    // transform value from Int? to String?
    if let value = value {
        return "\(value)"
    }
    return nil
})

let intTransform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
    
    if let value = value {
        return Int(value) ?? 0
    }
    return 0
    
}, toJSON: { (value: Int?) -> String? in
    // transform value from Int? to String?
    if let value = value {
        return "\(value)"
    }
    return nil
})
