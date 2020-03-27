//
//  HealthKitAuthorization.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/3/27.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitAuthorization {
  
  private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
    //1. Check to see if HealthKit Is Available on this device
    guard HKHealthStore.isHealthDataAvailable( ) else {
      completion(false, HealthkitSetupError.notAvailableOnDevice)
      return
    }
    //2. Prepare the data types that will interact with HealthKit
            // Birth Date
    guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            // Blood Type
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            // Sex
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            // BMI
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            // Body Fat
            let bodyFatPercentage = HKObjectType.quantityType(forIdentifier: .bodyFatPercentage),
            // height
            let height = HKObjectType.quantityType(forIdentifier: .height),
            // weight
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)
            else {
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
    }
    //3. Prepare a list of types you want HealthKit to read
    let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
                                                   bloodType,
                                                   biologicalSex,
                                                   bodyMassIndex,
                                                   height,
                                                   bodyMass,
                                                   bodyFatPercentage,
                                                   heartRate,
                                                   HKObjectType.workoutType( )]
    //4. Request Authorization
    HKHealthStore( ).requestAuthorization(toShare: nil,
                                         read: healthKitTypesToRead) { (success, error) in
      completion(success, error)
    }
  }
}

