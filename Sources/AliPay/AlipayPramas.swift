//
//  File.swift
//  
//
//  Created by xj on 2020/4/13.
//

import Vapor

public struct AlipayPramas: Content {
    public init(method: String, charset: String, sign: String = "", timestamp: String, notify_url: String, biz_content: String) {
        self.method = method
        self.charset = charset
        self.sign = sign
        self.timestamp = timestamp
        self.notify_url = notify_url
        self.biz_content = biz_content
    }

    let method: String
    let format = "JSON"
    let charset: String
    let sign_type: String = "RSA2"
    var sign: String
    let timestamp: String
    let version = "1.0"
    let notify_url: String
    let biz_content: String
}
