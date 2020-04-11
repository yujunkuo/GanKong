//
//  UserController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/3/27.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import Foundation
import HealthKit

class UserController {
    
    class func getAgeSexAndBloodType() throws -> (age: Int,
        biologicalSex: HKBiologicalSex,
        bloodType: HKBloodType) {
            
            let healthKitStore = HKHealthStore()
            
            do {
                
                //1. This method throws an error if these data are not available.
                let birthdayComponents =  try healthKitStore.dateOfBirthComponents()
                let biologicalSex =       try healthKitStore.biologicalSex()
                let bloodType =           try healthKitStore.bloodType()
                
                //2. Use Calendar to calculate age.
                let today = Date()
                let calendar = Calendar.current
                let todayDateComponents = calendar.dateComponents([.year],
                                                                  from: today)
                let thisYear = todayDateComponents.year!
                let age = thisYear - birthdayComponents.year!
                
                //3. Unwrap the wrappers to get the underlying enum values.
                let unwrappedBiologicalSex = biologicalSex.biologicalSex
                let unwrappedBloodType = bloodType.bloodType
                
                return (age, unwrappedBiologicalSex, unwrappedBloodType)
            }
    }
    
    
    class func getMostRecentSample(for sampleType: HKSampleType,
                                   completion: @escaping ([HKSample]?, Error?) -> Swift.Void) {
        var myAnchor = HKQueryAnchor.init(fromValue: 0)
        let anchorQuery = HKAnchoredObjectQuery(type: sampleType,
                                                predicate: nil,
                                                anchor: myAnchor,
                                                limit: HKObjectQueryNoLimit) { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
                                                    
                                                    DispatchQueue.main.async {
                                                        print(sampleType)
                                                        myAnchor = newAnchor!
                                                        
                                                        guard let samples = samplesOrNil,
                                                            let mostRecentSample = samples.last as? HKQuantitySample else {
                                                                print("Nil for", sampleType)
                                                                completion(nil, errorOrNil)
                                                                return
                                                        }
                                                        print("Not nil for", sampleType)
                                                        completion(samples, nil)
                                                    }
        }
        anchorQuery.updateHandler = { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            
            DispatchQueue.main.async {
                
                myAnchor = newAnchor!
                
                guard let samples = samplesOrNil,
                    let mostRecentSample = samples.last as? HKQuantitySample else {
                        
                        completion(nil, errorOrNil)
                        return
                }
                completion(samples, nil)
            }
            
            
            
        }
        HKHealthStore().enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion:  { (success: Bool, error: Error?) in
            debugPrint("enableBackgroundDeliveryForType handler called for \(sampleType) - success: \(success), error: \(error)")
            HKHealthStore().execute(anchorQuery)
        })
        
        
    }
    class func getCategoryTypeData(for sampleType: HKCategoryType, completion: @escaping ([HKSample]?, Error?) -> Swift.Void){
        var myAnchor = HKQueryAnchor.init(fromValue: 0)
        let anchorQuery = HKAnchoredObjectQuery(type: sampleType,
                                                predicate: nil,
                                                anchor: myAnchor,
                                                limit: HKObjectQueryNoLimit) { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
                                                    
                                                    DispatchQueue.main.async {
                                                        
                                                        print(sampleType)
                                                        myAnchor = newAnchor!
                                                        
                                                        guard let result = samplesOrNil else {
                                                            print("Nil for", sampleType)
                                                            completion(nil, errorOrNil)
                                                            return
                                                        }
                                                        print("Not nil for", sampleType)
                                                        completion(result, nil)
                                                    }
        }
        anchorQuery.updateHandler = { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            
            DispatchQueue.main.async {
                
                print(sampleType)
                myAnchor = newAnchor!
                
                guard let result = samplesOrNil else {
                    print("Nil for", sampleType)
                    completion(nil, errorOrNil)
                    return
                }
                print("Not nil for", sampleType)
                completion(result, nil)
            }
            
            
            
        }
        HKHealthStore().enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion:  { (success: Bool, error: Error?) in
            debugPrint("enableBackgroundDeliveryForType handler called for \(sampleType) - success: \(success), error: \(error)")
            HKHealthStore().execute(anchorQuery)
        })
    }
}
