//
//  File.swift
//  
//
//  Created by xj on 2020/4/12.
//

import Foundation

public enum AliPayMethod {
    case appPay
    
    var name: String {
        switch self {
        case .appPay: return "alipay.trade.app.pay"
        }
    }
}
