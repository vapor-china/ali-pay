//
//  File.swift
//  
//
//  Created by xj on 2020/4/12.
//

import Vapor

public enum AliPayMethod {
    case appPay
    case certDownload
    
    var name: String {
        switch self {
        case .appPay: return "alipay.trade.app.pay"
        case .certDownload: return "alipay.open.app.alipaycert.download"
        }
    }
}

enum AliPayURI {
    case product
    case sandbox
    case productMAPI
    
    var uri: URI {
        switch self {
        case .product: return URI(string: "https://openapi.alipay.com/gateway.do")
        case .sandbox: return URI(string: "https://openapi.alipaydev.com/gateway.do")
        case .productMAPI: return URI(string: "https://mapi.alipay.com/gateway.do")
        }
    }
}

public enum AliPayEnvir {
    case product
    case sandbox
    
    var uri: URI {
        switch self {
        case .product: return AliPayURI.product.uri
        case .sandbox: return AliPayURI.sandbox.uri
        }
    }
}

public enum Format: String {
    case JSON
}

public enum Charset {
    case utf8
    
    var name: String {
        switch self {
        case .utf8: return "utf-8"
        }
    }
}

public enum SignType: String {
    case RSA
    case RSA2
}

enum ContentType {
    case wwwFormUrlEncode
    
    var type: String {
        switch self {
        case .wwwFormUrlEncode: return "application/x-www-form-urlencoded;charset=utf-8"
        }
    }
}

enum TimeFormat {
    // g - | k   | c :
    case YYYYgMMgDDkHHcmmcss
    
    var format: String {
        switch self {
        case .YYYYgMMgDDkHHcmmcss: return "yyyy-MM-dd HH:mm:ss"
        }
    }
}
