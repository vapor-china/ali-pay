//
//  File.swift
//  
//
//  Created by xj on 2020/4/13.
//

import Vapor

final public class AliUnifiedOrderPramas: AliParams, Content {
  
  public init(body: String? = nil, subject: String, out_trade_no: String, tiemout_express: String? = nil, total_amount: String, product_code: String, goods_type: String? = nil, goods_detail: [String]? = nil, passback_params: String? = nil, promo_params: String? = nil, extend_params: String? = nil, enable_pay_channels: String? = nil, disable_pay_channels: String? = nil, store_id: String? = nil, ext_user_info: ExtUserInfo? = nil) {
      self.body = body
      self.subject = subject
      self.out_trade_no = out_trade_no
      self.tiemout_express = tiemout_express
      self.total_amount = total_amount
      self.product_code = product_code
      self.goods_type = goods_type
      self.goods_detail = goods_detail
      self.passback_params = passback_params
      self.promo_params = promo_params
      self.extend_params = extend_params
      self.enable_pay_channels = enable_pay_channels
      self.disable_pay_channels = disable_pay_channels
      self.store_id = store_id
      self.ext_user_info = ext_user_info
    super.init()
  }
    
    private enum CodingKeys: String, CodingKey {
        case body
        case subject
        case out_trade_no
        case tiemout_express
        case total_amount
        case product_code
        case goods_type
        case goods_detail
        case passback_params
        case promo_params
        case extend_params
        case enable_pay_channels
        case disable_pay_channels
        case store_id
        case ext_user_info
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.body = try container.decode(String.self, forKey: .body)
        self.subject = try container.decode(String.self, forKey: .subject)
        self.out_trade_no = try container.decode(String.self, forKey: .out_trade_no)
        self.tiemout_express = try container.decode(String.self, forKey: .tiemout_express)
        self.total_amount = try container.decode(String.self, forKey: .total_amount)
        self.product_code = try container.decode(String.self, forKey: .product_code)
        self.goods_type = try container.decode(String.self, forKey: .goods_type)
        self.goods_detail = try container.decode([String].self, forKey: .goods_detail)
        self.passback_params = try container.decode(String.self, forKey: .passback_params)
        self.promo_params = try container.decode(String.self, forKey: .promo_params)
        self.extend_params = try container.decode(String.self, forKey: .extend_params)
        self.enable_pay_channels = try container.decode(String.self, forKey: .enable_pay_channels)
        self.disable_pay_channels = try container.decode(String.self, forKey: .disable_pay_channels)
        self.store_id = try container.decode(String.self, forKey: .store_id)
        self.ext_user_info = try container.decode(ExtUserInfo.self, forKey: .ext_user_info)
        try super.init(from: decoder)
    }
    
 
    
  let body: String?
  let subject: String
  let out_trade_no: String
  let tiemout_express: String?
  let total_amount: String
  let product_code: String
  let goods_type: String?
  let goods_detail: [String]?
  let passback_params: String?
  let promo_params: String?
  let extend_params: String?
  let enable_pay_channels: String?
  let disable_pay_channels: String?
  let store_id: String?
  let ext_user_info: ExtUserInfo?
    
}

public struct AliExtendParams: Content {
    let sys_service_provider_id: String?
    let needBuyerRealnamed: String?
    let TRANS_MEMO: String?
    let hb_fq_num: String?
    let hb_fq_seller_percent: String?
}

public enum AliChannles: String, Content {
    case balance
    case moneyFund
    case coupon
    case pcredit
    case pcreditpayInstallment
    case creditCard
    case creditCardExpress
    case creditCardCartoon
    case credit_group
    case debitCardExpress
    case mcard
    case pcard
    case promotion
    case voucher
    case point
    case mdiscount
    case bankPay
    
}

public struct ExtUserInfo: Content {
    let name: String?
    let monile: String?
    let cert_type: String?
    let cert_no: String?
    let min_age: String?
    let fix_buyer: String?
    let need_check_inf: String?
}
