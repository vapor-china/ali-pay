//
//  File.swift
//  
//
//  Created by xj on 2020/4/12.
//

import Vapor
import ASN1Decoder
import CryptorRSA
import BigInt
import Crypto

public struct AliPaySign {
    
}

extension AliPaySign {
    static func generateStr(params: [String: String], isSign: Bool = true) -> String {
        var dic = params
        if isSign {
            let newDic = dic.filter { (key, value) -> Bool in
                if key == "sign" || value.isEmpty {
                    return false
                } else { return true }
            }
            dic = newDic
        }
        let dic2 = dic.sorted { (k1, k2) -> Bool in
            return k1.key < k2.key
        }
        
        var queryString = ""
        
        for (k,v) in dic2 {
            queryString = queryString + "&" + k + "=" + v
        }
        
        let signQuery = String(queryString.dropFirst(1))
        return signQuery
    }
}

extension AliPaySign {
    static func getCertSN(_ x509: X509Certificate) throws -> String {
    
    guard let serialNumberData = x509.serialNumber else {
        throw AlipayError(reason: "serail number data is nil")
    }
    let hexSN = serialNumberData.hexEncodedString()
    let serialNumberStr = BigInt(hexSN, radix: 16)?.description ?? ""
    
    let name = x509.issuerDistinguishedNameUnSpaceInterval ?? ""
    
    guard !name.isEmpty && !serialNumberStr.isEmpty else {
        throw AlipayError(reason: "iussuer name or serial number is empty")
    }
    
    let md5str = name + serialNumberStr
    let sn = AliPaySign.encodeWithMD5(content: md5str)
    return sn
    }
}

extension AliPaySign {
    static func encodeWithMD5(content: String, uppercase: Bool = false) -> String {
        let digest = Insecure.MD5.hash(data: Data(content.utf8))
        let str = digest.map { String(format: "%02hhx", $0) }.joined()
        if uppercase {
            return str.uppercased()
        } else {
            return str
        }
        
    }
    
    static func encodeWithHMAC<H: HashFunction>(content: String, key: String, type: H.Type) -> Data? {
        let keyData = key.data(using: .utf8)!
            
        let skey = SymmetricKey(data: keyData)
        var hmac = HMAC<H>(key: skey)
        
        let contentData = content.data(using: .utf8)!
        hmac.update(data: contentData)
        
        let result = hmac.finalize()
        
        let resultStr = result.map { String(format: "%02hhx", $0) }.joined()
        guard let data = resultStr.data(using: .utf8) else { return nil }
        
        return data
    }
}


extension AliPayClient {
    func parsePrivateKey(from base64key: String) throws -> CryptorRSA.PrivateKey {
        
        let rsa = try CryptorRSA.createPrivateKey(withBase64: base64key)
        return rsa
    }
    
    func parsePublicKey(from base64key: String) throws -> CryptorRSA.PublicKey {
        
        let publickey = try CryptorRSA.createPublicKey(withPEM: base64key)
        return publickey
    }
}
