//
//  Constant.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

let kDefaultScrollViewSideOffset = 40.0 as CGFloat
let kDefaultPointerLayerSideOffset = 2.0 as CGFloat
let kDefaultSegmentControlTitleFont = UIFont.sfProTextMedium(size: 15)
let kDefaultMarkerTypeFont: UIFont = UIFont.sfProTextMedium(size: 15)
let kDefaultTextFieldFont: UIFont = UIFont.sfProTextMedium(size: 15)
let kScrollAnimationSpeed: CGFloat = 300.0
let kRangeLayerMaximumWidth: Float = 7000.0
let kRangeLayerMaximumHeight: Float = 7000.0

let RUS = "ru"
let EN = "en"

class Constant {
    
    static let PAYMENT_COMPLETE = "PaymentComplete"
    static let SHOW_PRODUCT_LIST = "show_product_list"
    static let RELOAD_DIARY = "reload_diary"
    static let LOG_OUT = "log_out"
    static let MealtimeTitle = ["Завтрак", "Обед", "Перекус", "Ужин"]
}
