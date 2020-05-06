//
//  File.swift
//  
//
//  Created by xj on 2020/5/6.
//

import Vapor

struct CertDownloadResp: Content {
    let sign: String?
    let alipay_open_app_alipaycert_download_response: CertDownloadRespContent
}


struct CertDownloadRespContent: Content {
    let code: String
    let msg: String
    let sub_code: String?
    let sub_msg: String?
    let alipay_cert_content: String?
}
