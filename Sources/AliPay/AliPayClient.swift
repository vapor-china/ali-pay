//
//  File.swift
//  
//
//  Created by xj on 2020/4/12.
//

import Vapor
import CryptorRSA

public struct AliPayClient {
    
    let appid: String
    let privateKey: String
    
    
    var isProduction = false
    
    public init(appid: String, private key: String) throws {
        self.appid = appid
        self.privateKey = key
        self.privateRsaKey = try self.parsePrivateKey(from: key)
    }
    
    var appCertSN: String?
    var alipayRootCertSN: String?
    
    var privateRsaKey: CryptorRSA.PrivateKey?
    
    let format = "JSON"
    let charset = "utf-8"
    var signType = SignType.RSA2
    enum SignType: String {
        case RSA
        case RSA2
    }
}

extension AliPayClient {
    
    public func unifiedOrder(params content: AliUnifiedOrderPramas, notifyUrl: String) throws -> String {
        
        let bizContent = try serialization(params: content)
        var alipay = AlipayPramas(method: AliPayMethod.appPay.name, charset: charset, timestamp: AliSignTool.getCurrentTime(format: "yyyy-MM-dd HH:mm:ss"), notify_url: notifyUrl, biz_content: bizContent)
        let paramsDic = fillCertData(params: alipay)
        let signStr = AliPaySign.generateStr(params: paramsDic)
        let plainText = try CryptorRSA.createPlaintext(with: signStr, using: .utf8)
        var sign = ""
        if let rsa = privateRsaKey {
           let signature = try plainText.signed(with: rsa, algorithm: .sha256)
            if let signtrueData = signature {
               sign = signtrueData.base64String
            }
        }
        guard !sign.isEmpty else {
            throw AlipayError(reason: "签名异常")
        }
        alipay.sign = sign
        
        return generateRequestStr(params: alipay)
    }
    
    
    
}
extension AliPayClient {
    
    func serialization<T: Content>(params: T) throws -> String {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let jsonObject = try encoder.encode(params)
        let jsonStr = String(data: jsonObject, encoding: .utf8) ?? ""
        
        return jsonStr
    }
    
    func generateRequestStr<C: Content>(params: C) -> String {
//        let dic = MirrorExt.generateDic(model: params)
        let dic = fillCertData(params: params)
        let dic2 = dic.sorted { (k1, k2) -> Bool in
            return k1.key < k2.key
        }
        
        var queryString = ""
        
        for (k,v) in dic2 {
            queryString = queryString + "&" + k.aliSpecialUrlEncode() + "=" + v.aliSpecialUrlEncode()
        }
        
        let signQuery = String(queryString.dropFirst(1))
        return signQuery
    }
}

extension AliPayClient {
    
    func fillCertData<C: Content>(params: C) -> [String: String] {
        var dic = MirrorExt.generateDic(model: params)
        if let appCertSN = appCertSN {
            dic["app_cert_sn"] = appCertSN
        }
        if let alipayRootCertSN = alipayRootCertSN {
            dic["alipay_root_cert_sn"] = alipayRootCertSN
        }
        dic["app_id"] = appid
        
        return dic
    }
}

