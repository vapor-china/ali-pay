//
//  File.swift
//  
//
//  Created by xj on 2020/4/13.
//

import Foundation


class MirrorExt {

    static func generateDic<T>(model: T) -> Dictionary<String,String> {

        var para : [String : String] = [:]

        var mirror: Mirror? = Mirror(reflecting: model)
        repeat {
            for (fkey,fval) in mirror!.children {
                print("\(String(describing: fkey))")
                if case Optional<Any>.none = fval {
//                    print("nil")
                    continue
                }
                print("\(String(describing: fkey)) -- \(fval)")
                var val = ""
                if  case Optional.some(let value) = fval as? String {
                    print(value)
                    val = value
                } else if  case Optional.some(let value) = fval as? Int {
                    val = "\(value)"
                } else {
                     val = "\(fval)"
                }
                
                
                if let key = fkey, val != "" {
                   para[key] = val
                }
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
        
        return para
    }
}
