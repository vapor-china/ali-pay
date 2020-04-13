//
//  File.swift
//  
//
//  Created by xj on 2020/4/12.
//

import Foundation
import ASN1Decoder

extension X509Certificate {
    
    enum SigAlg: String {
        case SHA256WithRSA = "sha256WithRSAEncryption"
        case SHA1WithRSA = "sha1WithRSAEncryption"
    }
    
    
    var isSigAlgEncrySHA256ORSHA1: Bool {
        if sigAlgName == SigAlg.SHA1WithRSA.rawValue || sigAlgName == SigAlg.SHA256WithRSA.rawValue {
            return true
        } else {
            return false
        }
    }
}
