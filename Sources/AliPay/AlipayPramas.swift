//
//  File.swift
//  
//
//  Created by xj on 2020/4/13.
//

import Vapor

public struct AlipayUnifiedParamas: AlipayParams {
    public init(appid: String,method: String, charset: String, sign: String = "", timestamp: String, notify_url: String, biz_content: String) {
        self.method = method
        self.charset = charset
        self.sign = sign
        self.timestamp = timestamp
        self.notify_url = notify_url
        self.biz_content = biz_content
        self.app_id = appid
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
    var app_id: String
}
public struct CertDownloadParam: AlipayParams {
    public init(appid: String, method: AliPayMethod, format: Format = Format.JSON, charset: Charset = Charset.utf8, sign_type: SignType = SignType.RSA2, timestamp: String, app_auth_token: String? = nil, bizContent: String) {
        self.method = method.name
        self.format = format.rawValue
        self.charset = charset.name
        self.sign_type = sign_type.rawValue
        self.timestamp = timestamp
        self.version = "1.0"
        self.app_auth_token = app_auth_token
        self.biz_content = bizContent
        self.app_id = appid
    }
    
//    let app_id: String
    let method: String
    let format: String
    let charset: String
    let sign_type: String
    var sign: String = ""
    let version: String
    let timestamp: String
    let app_auth_token: String?
    let biz_content: String
    var app_id: String
}


struct CertDownload: Content {
    let alipay_cert_sn: String
}


protocol AlipayParams: Content {
    var sign: String { get set }
    var app_id: String { get set }
}
