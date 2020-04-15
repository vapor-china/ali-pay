//
//  File.swift
//  
//
//  Created by xj on 2020/4/12.
//

import Foundation
import ASN1Decoder

extension AliPayClient {
    
    mutating public func registerAppPublicCert(_ pemStr: String) throws {
        let appPubCertData = pemStr.data(using: .utf8)
        if let certData = appPubCertData {
            let x509 = try X509Certificate(data: certData)
            let sn = try AliPaySign.getCertSN(x509)
            
            self.appCertSN = sn
        }
    }
    
    mutating public func registerAliPayRootCert(_ pemStr: String) throws {
        var certStrArray = pemStr.components(separatedBy: endPemBlock)
        var certSNArray: [String] = []
        certStrArray = certStrArray.dropLast()
        for certPreStr in certStrArray {
            let certStr = certPreStr + endPemBlock
            if let certData = certStr.data(using: .utf8) {
                let cert = try X509Certificate(data: certData)
                if cert.isSigAlgEncrySHA256ORSHA1 {
                    let sn = try AliPaySign.getCertSN(cert)
                    certSNArray.append(sn)
                }
            }
        }
        let result = certSNArray.joined(separator: "_")
        self.alipayRootCertSN = result
    }
    
    private var beginPemBlock: String { "-----BEGIN CERTIFICATE-----" }
    private var endPemBlock: String { "-----END CERTIFICATE-----" }
}
