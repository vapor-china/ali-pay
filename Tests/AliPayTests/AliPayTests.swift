//
//  File.swift
//  
//
//  Created by xj on 2020/4/12.
//

import XCTest

@testable import AliPay

@available(macOS 10.12, iOS 10.3, watchOS 3.3, tvOS 12.0, *)
class AliPayTests: XCTestCase {
    
    
    func testUnified() throws {
        var client = try AliPayClient(appid: "2019102268523970", private: pcks1Str)
                try client.registerAppPublicCert(appPubCertStr)
                try client.registerAliPayRootCert(rootCertStr)
                
//                let unified = try client.testUnifiedOrder()
        //        return result.encodeResponse(for: req)
//                let plainText = try CryptorRSA.createPlaintext(with: unified, using: .utf8)
                
                var sign = ""
//                if let rsa = client.privateRsaKey {
//                   let signature = try plainText.signed(with: rsa, algorithm: .sha256)
//                    if let signtrueData = signature {
//                       sign = signtrueData.base64String
//                    }
//                }
        print(sign)
    }
}

