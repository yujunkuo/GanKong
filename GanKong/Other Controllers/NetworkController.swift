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
    
    func postHeartRateData (data: String, time: String, completion: @escaping(Int?) -> Void) {
        let heartRateURL = baseURL.appendingPathComponent("heart_rate/1")
        var request = URLRequest(url: heartRateURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["heart_rate_data": data, "heart_rate_time": time]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data,
        response, error) in
            
        }
        task.resume( )
    }
}

