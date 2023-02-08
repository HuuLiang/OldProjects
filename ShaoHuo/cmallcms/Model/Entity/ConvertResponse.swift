//
//  ConvertResponse.swift
//  cmallcms
//
//  Created by vicoo on 2017/5/23.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import Foundation
import EZSwiftExtensions

func ConverNetworkResponse(responseData: [String : AnyObject]) -> (dicData: [String: AnyObject]?, error: CMCError?) {
    
    var code: Int? =  responseData["code"] as? Int
    if code == nil {
        code = (responseData["code"] as! String).toInt() ?? 0
    }
    
    if code == 0 {
        if let data = responseData["data"] as? [String : AnyObject] {
            return (data, error: nil)
        }
        else {
            return (nil, error: nil)
        }
    }
    else {
        let info = responseData["msg"] as! String
        return (nil,error: CMCError.responseError(code: code ?? 0, message: info))
    }
}
