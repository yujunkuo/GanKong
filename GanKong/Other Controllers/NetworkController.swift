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
    
    // Login
    func login (account: String, password: String, completion: @escaping([Any]?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("login")
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["account": account, "password": password]
        let jsonEncoder = JSONEncoder( )
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
            { (data, response, error) in
                    if let data = data,
                        let jsonDictionary = try?
                        JSONSerialization.jsonObject(with: data) as?
                        [String: Any],
                        let status_code = jsonDictionary["status_code"] as? Int,
                            let session_id = jsonDictionary["session_id"] as? String{
                                completion([status_code, session_id])
                        } else {
                            completion(nil)
                        }
            }
        task.resume( )
    }
    
    
    // Register
    func register (account: String, password: String, completion: @escaping(Int?) -> Void) {
        let registerURL = baseURL.appendingPathComponent("register")
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["account": account, "password": password]
        let jsonEncoder = JSONEncoder( )
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
            { (data, response, error) in
                    if let data = data,
                        let jsonDictionary = try?
                        JSONSerialization.jsonObject(with: data) as?
                        [String: Int],
                        let status_code = jsonDictionary["status_code"] {
                                completion(status_code)
                        } else {
                            completion(nil)
                        }
            }
        task.resume( )
    }
    
    
    // Check is login or not
    func checkLoginOrNot (completion: @escaping([String]?) -> Void) {
        let checkLoginURL = baseURL.appendingPathComponent("check_login")
        let task = URLSession.shared.dataTask(with: checkLoginURL)
            { (data, response, error) in
                if let data = data,
                    let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                    [String: Any],
                    let loginInformation = jsonDictionary["data"] as? [String] {
                        completion(loginInformation)
                    } else {
                        completion(nil)
                 }
        }
        task.resume( )
    }
    
    
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
    
    func postStepCountData (data: String, time: String, completion: @escaping(Int?) -> Void) {
        let stepCountURL = baseURL.appendingPathComponent("step_count/1")
        var request = URLRequest(url: stepCountURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["step_count_data": data, "step_count_time": time]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data,
        response, error) in
            
        }
        task.resume( )
    }
}

