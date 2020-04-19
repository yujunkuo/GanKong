//
//  HelperController.swift
//  GanKong
//
//  Created by 施君諺 on 2020/4/17.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import Foundation

class HelperController{
    
    public func string2TimeStamp(_ string:String, dateFormat:String = "yyyy-MM-dd") -> TimeInterval {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_TW")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        let timeStamp: TimeInterval = date!.timeIntervalSince1970
        return timeStamp
    }
    
}
