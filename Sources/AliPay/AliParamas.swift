//
//  File.swift
//  
//
//  Created by xj on 2020/4/13.
//

import Vapor

public struct AliPayCallbackResp: Content {
    
    let sign_type: String
    let invoice_amount: String
    let out_trade_no: String
    let gmt_create: String
    let subject: String
    let version: String
    let receipt_amount: String
    let trade_no: String
    let total_amount: String
    let auth_app_id: String
    let notify_type: String
    let buyer_id: String
    let seller_email: String
    let point_amount: String
    let buyer_pay_amount: String
    let seller_id: String
    let notify_id: String
    let app_id: String
    let sign: String
    let trade_status: String
    let gmt_payment: String
    let fund_bill_list: String
    let charset: String
    let buyer_logon_id: String
    let notify_time: String
    
    var alipay_cert_sn: String?
}

