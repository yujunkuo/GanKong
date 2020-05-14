//
//  NetworkController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/3/27.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

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
    
    
    func postFoodData(base64String: String) {
        
            let boundary = "Boundary-\(UUID().uuidString)"
            let foodURL = self.baseURL.appendingPathComponent("food")
            var request = URLRequest(url: foodURL)
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"

            var body = ""
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"image\""
            body += "\r\n\r\n\(base64String)\r\n"
            body += "--\(boundary)--\r\n"
            let postData = body.data(using: .utf8)

            request.httpBody = postData

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("failed with error: \(error)")
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                    print("server error")
                    return
                }
                if let mimeType = response.mimeType, mimeType == "application/json", let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("imgur upload results: \(dataString)")

                    let parsedResult: [String: AnyObject]
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                        if let dataJson = parsedResult["data"] as? [String: Any] {
                            print("Link is : \(dataJson["link"] as? String ?? "Link not found")")
                        }
                    } catch {
                        // Display an error
                    }
                }
            }.resume( )
        }
    
    func postExerciseData (exerciseType: String, calories: Double, startTime: String, endTime: String, session_id: String, completion: @escaping(Int?) -> Void) {
        let exerciseURL = baseURL.appendingPathComponent("exercise")
        var request = URLRequest(url: exerciseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let data: [String: String] = ["session_id": session_id, "exercise_Type": exerciseType,  "exercise_calories": String(calories), "exercise_start_time": startTime, "exercise_end_time":endTime]
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
    
//    var placesClient: GMSPlacesClient!
//    var nearbyPlaces:[Location] = []
//
//    func getNearby(lat: CLLocationDegrees, lng:CLLocationDegrees) -> [Location]{
//        nearbyPlaces.removeAll()
//        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
//            if let error = error {
//                // TODO: Handle the error.
//                print("Current Place error: \(error.localizedDescription)")
//                return
//            }
//
//            // Get likely places and add to the list.
//            if let likelihoodList = placeLikelihoods {
//                for likelihood in likelihoodList.likelihoods {
//                    if likelihood.place.types == ["restaurant"]{
//                        let place = likelihood.place
//
//                        var rating:Float = -1.0
//
//                        if place.rating != nil {
//
//                            guard let rlevel = place.rating as? Float else {
//                                return
//                            }
//                            rating = rlevel
//                        }
//
//                        var photo:[GMSPlacePhotoMetadata] = []
//
//                        if place.photos != nil{
//                            guard let photoChoose = place.photos as? [GMSPlacePhotoMetadata] else{
//                                return
//                            }
//                            photo = photoChoose
//                        }
//
//
//                        guard
//                            let latitude = place.coordinate.latitude as? CLLocationDegrees,
//                            let longitude = place.coordinate.longitude as? CLLocationDegrees,
//                            let name = place.name,
//                            let placeId = place.placeID,
//                            let types = place.types,
//                            let openingHours = place.openingHours?.weekdayText,
//                            let address = place.formattedAddress as? String else {
//                                return
//                        }
//
//                        let location = Location(latitude: latitude,
//                                                longitude: longitude,
//                                                name: name,
//                                                placeId: placeId,
//                                                openingHours: openingHours,
//                                                rating: rating,
//                                                types: types,
//                                                photo: photo,
//                                                address: address)
//
//                        self.nearbyPlaces.append(location)
//                    }
//                }
//            }
//        })
//        return self.nearbyPlaces
//    }

    
}

