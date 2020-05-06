//
//  File.swift
//  
//
//  Created by xj on 2020/4/12.
//

import Foundation
import ASN1Decoder
import CryptorRSA
import Crypto

extension AliPayClient {
    
     public func registerAppPublicCert(_ pemStr: String) throws {
        let appPubCertData = pemStr.data(using: .utf8)
        if let certData = appPubCertData {
            let x509 = try X509Certificate(data: certData)
            let sn = try AliPaySign.getCertSN(x509)
            
            self.appCertSN = sn
        }
    }
    
     public func registerAliPayRootCert(_ pemStr: String) throws {
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
    
     public func registerAliPayPublicCert(_ pemStr: String) throws {
        
        var certStrArray = pemStr.components(separatedBy: endPemBlock)
//        var certSNArray: [String] = []
        certStrArray = certStrArray.dropLast()
       
        if certStrArray.count > 0 {
            let certStr = certStrArray[0] + endPemBlock
            if let certData = certStr.data(using: .utf8) {
                let cert = try X509Certificate(data: certData)
                if cert.isSigAlgEncrySHA256ORSHA1 {
                    let sn = try AliPaySign.getCertSN(cert)
                    aliPublicCertSN = sn
//                    certSNArray.append(sn)
                    if let publicKey = cert.publicKey {
//                        print(publicKey)
//                        publicKeyDic[sn] = publicKey
                    }
                }
//                cert.publicKey
            }

        
        }
    }
        
     func saveAlipayPublicKey(_ pemStr: String) throws -> ASN1Decoder.X509PublicKey {
            
            guard let sn = aliPublicCertSN else { throw AlipayError(reason: "save alipay public key failed, by not have pulic cert sn") }
                
                var certStrArray = pemStr.components(separatedBy: endPemBlock)
        //        var certSNArray: [String] = []
                certStrArray = certStrArray.dropLast()
               
                if certStrArray.count > 0 {
                    let certStr = certStrArray[0] + endPemBlock
                    if let certData = certStr.data(using: .utf8) {
                        let cert = try X509Certificate(data: certData)
//                        let cyrptor = try CryptorRSA.createPublicKey(withPEM: pemStr)
//                        let base64String = try CryptorRSA.base64String(for: certStr)
//                        let s = try CryptorRSA.createPublicKey(withBase64: base64String)
//                        try CryptorRSA.createPlaintext(with: certData)
                        
                        
                        
                        if cert.isSigAlgEncrySHA256ORSHA1 {
//                            let sn = try AliPaySign.getCertSN(cert)
//                            aliPublicCertSN = sn
        //                    certSNArray.append(sn)
                            if let publicKey = cert.publicKey {
        //                        print(publicKey)
                                publicKeyDic[sn] = publicKey
                                
                                if let key = publicKey.key {
                                    try CryptorRSA.createPublicKey(with: key)
                                }
                                
                                return publicKey
                            }
                        }
        //                cert.publicKey
                    }
            }
                throw AlipayError(reason: "parse error")
        }
}
