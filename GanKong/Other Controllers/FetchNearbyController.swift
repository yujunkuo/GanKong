//
//  FetchNearby.swift
//  GanKong
//
//  Created by 施君諺 on 2020/5/5.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import Foundation
import GooglePlaces
import Alamofire

protocol FetchLocationDelegate: class {
    func manager(_ manager: FetchNearbyLocationManager, didGet nearLocations: [Location])
    func manager(_ manager: FetchNearbyLocationManager, didFailWith error: Error)
    func manager(_ manager: FetchNearbyLocationManager, didFailWith noDataIn: String)
}

enum FetchError: Error {
    case invalidFormatted
}

class fetchNearbyManager{
    
    weak var delegate: FetchLocationDelegate?
    
    var location = Location[]
    
    var keyCount = 0
    
    func requestNearbyLocation(latitude: Float, longitude: Float, radius: Float) {
        
        let key = "AIzaSyCBabIKFA2_WgOIB6AdYh_5ofZau6ttN3Q"
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude)\(longitude)&radius=\(radius)&type=restaurant&key=\(key)"
        
        print(urlString)
        
        fetchRequestHandler(urlString: urlString)
    }
    
    func fetchRequestHandler(urlString: String){
        Location = []
        
        let APIurl = urlString
        
        Alamofire.request(APIurl as! URLRequestConvertible).responseJSON(completionHandler: {response in
            let responseJSON = response.result.value
            guard
                let localJson = responseJSON as? [String: Any],
                let status = localJson["status"] as? String else {
                    print("NO Status")
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
            }
            if (status == "OVER_QUERY_LIMIT" || status == "INVALID_REQUEST") {
                if self.keyCount < 4 {
                    self.keyCount += 1
                    self.fetchRequestHandler(urlString: "")
                }
                else{
                    self.keyCount = 0
                    self.fetchRequestHandler(urlString: "")
                }
            }
            
            guard let results = localJson["results"] as? [[String: Any]] else{
                return
            }
            
            if results.count == 0 {
                print("No data inside")
                self.delegate?.manager(self, didFailWith: "請重新呼叫LocationManager")
                return
            }
            
            var photoReference = ""
            
            for result in results{
                if result["Photo"] != nil{
                    guard
                        let photos = result["photos"] as? [[String: Any]],
                        let reference = photos[0]["photo_reference"] as? String else {
                            self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                            return
                    }
                    photoReference = reference
                }
                
                guard
                    let geometry = result["geometry"] as? [String:Any],
                    let id = result["id"] as? String,
                    let name = result["name"] as? String,
                    let placeId = result["place_id"] as? String,
                    let types = result["types"] as? [String],
                    let location = geometry["location"] as? [String:Any],
                    let latitude = location["lat"] as? CLLocationDegrees,
                    let longitude = location["lng"] as? CLLocationDegrees,
                    let openOrNot = location["opening_hours"]["open_now"],
                    let vinicity = location["vicinity"] as? Bool else {
                        return
                }
                
                let locationData = Location(latitude: latitude,
                                            longitude: longitude,
                                            name: name,
                                            id: id,
                                            placeId: placeId,
                                            types: types,
                                            priceLevel: priceLevel,
                                            rating: rating,
                                            photoReference: photoReference,
                                            openOrNot: openOrNot,
                                            vicinity: vicinity)
                
                self.location.append(locationData)
                
                print(location.name)
                print(location.type)
                print(location.openOrNot)
            }
            self.delegate?.manager(self, didGet: self.locations)
        })
    }
}