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
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?, Bool) -> Swift.Void) {
        //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable( ) else {
            completion(false, HealthkitSetupError.notAvailableOnDevice, false)
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
            let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
            let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
            let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
            else {
                completion(false, HealthkitSetupError.dataTypeNotAvailable, false)
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
                                                       stepCount,
                                                       sleepAnalysis,
                                                       HKObjectType.workoutType( )]
        //4. Request Authorization
        HKHealthStore( ).requestAuthorization(toShare: nil,
                read: healthKitTypesToRead) { (success, error) in
                       let dateOfBirthAuthorizationStatus = HKHealthStore( ).authorizationStatus(for: dateOfBirth)
                       let bloodTypeAuthorizationStatus = HKHealthStore( ).authorizationStatus(for: bloodType)
                       let biologicalSexAuthorizationStatus = HKHealthStore( ).authorizationStatus(for: biologicalSex)
                       let bodyMassIndexAuthorizationStatus = HKHealthStore( ).authorizationStatus(for: bodyMassIndex)
                       let bodyFatPercentageAuthorizationStatus = HKHealthStore( ).authorizationStatus(for: bodyFatPercentage)
                       let heightAuthorizationStatus = HKHealthStore( ).authorizationStatus(for: height)
                       let bodyMassAuthorizationStatus = HKHealthStore( ).authorizationStatus(for: bodyMass)
                       let heartRateAuthorizationStatus = HKHealthStore( ).authorizationStatus(for: heartRate)
                       let stepCountAuthorizationStatus = HKHealthStore( ).authorizationStatus(for: stepCount)
                       let sleepAnalysisAuthorizationStatus = HKHealthStore( ).authorizationStatus(for: sleepAnalysis)

                    if (dateOfBirthAuthorizationStatus == .sharingAuthorized
                        && sleepAnalysisAuthorizationStatus == .sharingAuthorized
                        && bloodTypeAuthorizationStatus == .sharingAuthorized
                        && biologicalSexAuthorizationStatus == .sharingAuthorized
                        && bodyMassIndexAuthorizationStatus == .sharingAuthorized
                        && bodyFatPercentageAuthorizationStatus == .sharingAuthorized
                        && heightAuthorizationStatus == .sharingAuthorized
                        && bodyMassAuthorizationStatus == .sharingAuthorized
                        && heartRateAuthorizationStatus == .sharingAuthorized
                        && stepCountAuthorizationStatus == .sharingAuthorized
                        && sleepAnalysisAuthorizationStatus == .sharingAuthorized) {
                            completion(success, error, true)
                    } else {
                         completion(success, error, false)
                    }
                }
                   
        }
    }


