//
//  NetworkController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/3/27.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import Foundation

class NetworkController {
    
    // API URL
    let baseURL = URL(string: "http://140.119.19.18:5000/")!
    
    // use GET Request to get the heart rate data
    func fetchHeartRateData (completion: @escaping ([Double]?) -> Void) {
        let heartRateURL = baseURL.appendingPathComponent("heart_rate")
        let task = URLSession.shared.dataTask(with: heartRateURL)
            { (data, response, error) in
                if let data = data,
                    let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                    [String:Any],
                    let heartRateData = jsonDictionary["data"] as?
                    [Double] {
                    completion(heartRateData)
                 } else {
                    completion(nil)
                 }
        }
        task.resume( )
    }
}

