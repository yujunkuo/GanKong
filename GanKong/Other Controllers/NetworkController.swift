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
    func register (account: String, password: String, completion: @escaping([Any]?) -> Void) {
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
    
    
    // Logout
    func logout (session_id: String, completion: @escaping(Int?) -> Void) {
        let logoutURL = baseURL.appendingPathComponent("logout")
        var request = URLRequest(url: logoutURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["session_id": session_id]
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
    func checkLogin (session_id: String, completion: @escaping(Int?) -> Void) {
        let checkLoginURL = baseURL.appendingPathComponent("check_login")
        var request = URLRequest(url: checkLoginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["session_id": session_id]
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
    
    func postHeartRateData (data: String, time: String, session_id: String, completion: @escaping(Int?) -> Void) {
        let heartRateURL = baseURL.appendingPathComponent("heart_rate")
        var request = URLRequest(url: heartRateURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["session_id": session_id ,"heart_rate": data, "heart_rate_time": time]
        let jsonEncoder = JSONEncoder()
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
    
    func postStepCountData (data: String, time: String, session_id: String, completion: @escaping(Int?) -> Void) {
        let stepCountURL = baseURL.appendingPathComponent("step_count")
        var request = URLRequest(url: stepCountURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["session_id": session_id ,"step_count": data, "step_count_time": time]
        let jsonEncoder = JSONEncoder()
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
    
    func postSleepData (inBed: Bool, startDate: String, endDate: String, session_id: String, completion: @escaping(Int?) -> Void) {
        let sleepURL = baseURL.appendingPathComponent("sleep")
        var request = URLRequest(url: sleepURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["session_id": session_id ,"in_bed": String(inBed), "start_date": startDate, "end_date": endDate]
        let jsonEncoder = JSONEncoder()
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
    
    func getWeatherData (lat: Double, lon: Double, completion: @escaping ([Dictionary<String, Any>]?) -> Void){
        let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=e0e24c33f68f469d16c6cf7b937f47bb")!
        let task = URLSession.shared.dataTask(with: weatherURL)
            { (data, response, error) in
                if let data = data,
                    let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                    [String:Any],
                    let weatherData = jsonDictionary["weather"] as?
                        [Dictionary<String, Any>] {
                    completion(weatherData)
                 } else {
                    completion(nil)
                 }
        }
        task.resume( )
    }
    
    func postWaterData (volume: Int, time: String, session_id: String, completion: @escaping(Int?) -> Void) {
        let waterURL = baseURL.appendingPathComponent("water")
        var request = URLRequest(url: waterURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["session_id": session_id ,"water_volume": String(volume), "water_time": time]
        let jsonEncoder = JSONEncoder()
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
    
    func postDrinkData (drinkType: String, volume: Double, calories: Double, time: String, session_id: String, completion: @escaping(Int?) -> Void) {
        let drinkURL = baseURL.appendingPathComponent("drink")
        var request = URLRequest(url: drinkURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["session_id": session_id, "drink_type": drinkType, "drink_volume": String(volume), "drink_calories": String(calories), "drink_time": time]
        let jsonEncoder = JSONEncoder()
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
    
    
    
}

