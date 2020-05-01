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
    
    var isProduction = AliPayEnvir.product
    
    public init(appid: String, private key: String) throws {
        self.appid = appid
        self.privateKey = key
        self.privateRsaKey = try self.parsePrivateKey(from: key)
    }
    
    var appCertSN: String?
    var alipayRootCertSN: String?
    var aliPublicCertSN: String?
    
    var privateRsaKey: CryptorRSA.PrivateKey?
    var publicRsaKey: CryptorRSA.PublicKey?
    
    var publicKeyDic = [String: CryptorRSA.PublicKey]()
    
    let format = Format.JSON
    let charset = Charset.utf8
    var signType = SignType.RSA2
    let timeFormat = TimeFormat.YYYYgMMgDDkHHcmmcss
}

extension AliPayClient {
    
    public func unifiedOrder(params content: AliUnifiedOrderPramas, notifyUrl: String) throws -> String {
        
        let bizContent = try serialization(params: content)
        var alipay = AlipayPramas(method: AliPayMethod.appPay.name, charset: charset.name, timestamp: AliSignTool.getCurrentTime(format: timeFormat.format), notify_url: notifyUrl, biz_content: bizContent)
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
    
    public func dealwithCallback(req: Request) throws -> AliPayCallbackResp {
        
        let resp = try req.content.decode(AliPayCallbackResp.self)
        
        guard let publicKey = publicRsaKey  else {
            throw AlipayError(reason: "公钥不存在")
        }
        
        return resp
    }
    
    func verifySign(resp: AliPayCallbackResp) throws {
        
        let sn = resp.alipay_cert_sn
        try getAliPayPublicKey(cert: sn)
    }
    
    struct CertDownload: Content {
        let app_auth_token: String?
        let alipay_cert_sn: String
    }
    
    struct CertDownloadResp: Content {
        let sign: String
        let alipay_open_app_alipaycert_download_response: CertDownloadRespContent
    }
    
    struct CertDownloadRespContent: Content {
        let code: String
        let msg: String
        let sub_code: String
        let sub_msg: String
        let alipay_cert_content: String
    }
    
    func getAliPayPublicKey(cert sn: String?) throws -> CryptorRSA.PublicKey {
        
        var sn = sn ?? ""
        if sn.isEmpty {
            guard let certSN = aliPublicCertSN, !certSN.isEmpty else { throw AlipayError(reason: "") }
            sn = certSN
        }
        
        if let key = publicKeyDic[sn] {
            return key
        }
        
        if isProduction == .product {
            
        }
        
    }
    
    func download(cert sn: String, req: Request) {
        
        var down = CertDownload(app_auth_token: nil, alipay_cert_sn: sn)
        req.client.post(isProduction.uri) { req in
            try req.content.encode(down)
        }.flatMapThrowing { (resp) -> CertDownloadResp in
           return try resp.content.decode(CertDownloadResp.self)
        }
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

