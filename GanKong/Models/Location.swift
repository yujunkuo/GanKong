//
//  Location.swift
//  GanKong
//
//  Created by 施君諺 on 2020/5/5.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import Foundation

struct Location {
    
    var latitude: Double
    var longitude: Double
    var name: String
    var id: String
    var placeId: String
    var types: [String]
    var priceLevel: Double?
    var rating: Double?
    var openingHours: [String: Any]
    var formattedPhoneNumber: String
    var reviewsText: [String]
    var website: String
    var photoReference: String
    //var photo: UIImage?
    var distanceText: String
    var durationText: String
    var openOrNot: Bool,
    var vicinity: String

    //一開始先找nearby使用的init
    init(latitude: Double, longitude: Double, name: String, id: String, placeId: String,
         types: [String], priceLevel: Double?, rating: Double?, photoReference: String, openOrNot: Bool) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.id = id
        self.placeId = placeId
        self.types = types
        self.priceLevel = priceLevel
        self.rating = rating
        self.photoReference = photoReference
        self.openingHours = [:]
        self.formattedPhoneNumber = ""
        self.reviewsText = []
        self.website = ""
        self.distanceText = ""
        self.durationText = ""
        self.openOrNot = openOrNot
        self.vicinity = ""
    }
    
}
