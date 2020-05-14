//
//  Location.swift
//  GanKong
//
//  Created by 施君諺 on 2020/5/5.
//  Copyright © 2020 KuoKuo. All rights reserved.
//
import UIKit
import Foundation
import GooglePlaces

struct Location {
    
    var latitude: Double
    var longitude: Double
    var name: String
    var placeId: String
    var types: [String]
    var priceLevel: Double?
    var rating: Double?
    var openingHours: [String: Any]
    var formattedPhoneNumber: String
    var reviewsText: [String]
    var website: String
    var photoReference: String
    var distanceText: String
    var durationText: String
    var vicinity: String

    //一開始先找nearby使用的init
    init(latitude: Double, longitude: Double, name: String, placeId: String, openingHours: [String: Any], rating: Double,
         types: [String], photoReference: String, vicinity: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.placeId = placeId
        self.types = types
//        self.priceLevel = priceLevel
        self.rating = rating
        self.photoReference = "photo"
        self.openingHours = openingHours
        self.formattedPhoneNumber = ""
        self.reviewsText = []
        self.website = ""
        self.distanceText = ""
        self.durationText = ""
        self.vicinity = ""
    }
    
}
