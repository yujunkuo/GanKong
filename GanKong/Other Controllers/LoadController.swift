////
////  LoadController.swift
////  GanKong
////
////  Created by 施君諺 on 2020/4/23.
////  Copyright © 2020 KuoKuo. All rights reserved.
////
//
//import Foundation
//import UIKit
//import HealthKit
//
//class LoadController{
//
//    var user = User( )
//    let networkController = NetworkController( )
//
//
//    public func loadAndDisplayAgeSexAndBloodType() -> Bool{
//        do {
//            let userAgeSexAndBloodType = try UserController.getAgeSexAndBloodType()
//            user.age = userAgeSexAndBloodType.age
//            user.biologicalSex = userAgeSexAndBloodType.biologicalSex
//            user.bloodType = userAgeSexAndBloodType.bloodType
//        } catch let error {
//            return false
//        }
//    }
//
//    public func loadAndDisplayMostRecentHeight() -> Bool{
//
//        //1. Use HealthKit to create the Height Sample Type
//        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
//            print("Height Object Type is no longer available in HealthKit")
//            return true
//        }
//
//        UserController.getMostRecentSample(for: heightSampleType) { (sample, error) -> Bool in
//
//            if (sample != nil){
//                print("Got Height")
//            }else{
//                print("Height Not Found")
//            }
//
//            guard let sample = sample else {
//
//                if let error = error {
//                    return false
//                }
//
//                return true
//            }
//
//            //2. Convert the height sample to meters, save to the profile model,
//            //   and update the user interface.
//            let lastsample = sample.last as? HKQuantitySample
//            let heightInMeters = lastsample!.quantity.doubleValue(for: HKUnit.meter())
//            self.user.heightInMeters = heightInMeters
//        }
//    }
//
//    public func loadAndDisplayMostRecentHeartRate() {
//
//        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
//            print("Heart Rate Sample Type is no longer available in HealthKit")
//            return
//        }
//
//        UserController.getMostRecentSample(for: heartRateType) { (sample, error) in
//
//            if (sample != nil){
//                print("Got HR")
//            }else{
//                print("HR Found")
//            }
//
//            guard let sample = sample else {
//
//                if let error = error {
//                    self.displayAlert(for: error)
//                }
//                return
//            }
//            let lastsample = sample.last as? HKQuantitySample
//            let heartRate = HKUnit(from: "count/min")
//            let heartRateperMins = lastsample!.quantity.doubleValue(for: heartRate)
//            self.user.heartRatePerMins = heartRateperMins
//            let HRdate = lastsample!.startDate
//            print(type(of: HRdate))
//            self.user.heartRateDate = HRdate
//
//            let now = NSDate()
//            let nowTimeStamp: TimeInterval = now.timeIntervalSince1970
//            let weekAgo = nowTimeStamp - 604800
//            // 604800 one week
//            // 86400 one day
//            for each in sample{
//                let each = each as? HKQuantitySample
//                let eachHRdate = each!.startDate
//                let HRtimeStamp: TimeInterval = eachHRdate.timeIntervalSince1970
//                if (HRtimeStamp > weekAgo){
//                    let HRtimeStampString = String(HRtimeStamp)
//                    let eachheartRateperMins = each!.quantity.doubleValue(for: heartRate)
//                    let heartRateFormatter = NumberFormatter()
//                    let heartRateData = heartRateFormatter.string(for: eachheartRateperMins)
//
//                    self.networkController.postHeartRateData(data: heartRateData!, time: HRtimeStampString, session_id: self.user.session_id!) {
//                        (status_code) in
//                        if (status_code != nil) {
//                            print(status_code!)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    public func loadAndDisplayMostRecentStep() {
//
//        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
//            print("Step Count Sample Type is no longer available in HealthKit")
//            return
//        }
//
//        UserController.getMostRecentSample(for: stepCountType) { (sample, error) in
//
//            if (sample != nil){
//                print("Got Step")
//            }else{
//                print("Step Not Found")
//            }
//
//            guard let sample = sample else {
//
//                if let error = error {
//                    self.displayAlert(for: error)
//                }
//                return
//            }
//            let lastsample = sample.last as? HKQuantitySample
//            let stepCount = HKUnit(from: "count")
//            let stepCountDouble = lastsample!.quantity.doubleValue(for: stepCount)
//            self.user.stepCount = Int(stepCountDouble)
//            let SCdate = lastsample!.startDate
//            self.user.stepCountDate = SCdate
//
//            let now = NSDate()
//            let nowTimeStamp: TimeInterval = now.timeIntervalSince1970
//            let weekAgo = nowTimeStamp - 604800
//            //604800 one week
//            //86400 one day
//            for each in sample{
//                let each = each as? HKQuantitySample
//                let eachSCdate = each!.startDate
//                let SCtimeStamp: TimeInterval = eachSCdate.timeIntervalSince1970
//                if(SCtimeStamp > weekAgo){
//                    let SCtimeStampString = String(SCtimeStamp)
//
//                    let eachstepCountDouble = each!.quantity.doubleValue(for: stepCount)
//                    let stepCountFormatter = NumberFormatter()
//                    let stepCountData = stepCountFormatter.string(for: eachstepCountDouble)
//
//                    self.networkController.postStepCountData(data: stepCountData!, time: SCtimeStampString, session_id: self.user.session_id!) {
//                        (status_code) in
//                            if (status_code != nil) {
//                                print(status_code!)
//                            }
//                    }
//                }
//            }
//        }
//    }
//
//    public func loadAndDisplayMostRecentSleepAnalysis() {
//        guard let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) else {
//            print("Sleep Analysis Sample Type is no longer available in HealthKit")
//            return
//        }
//
//        UserController.getCategoryTypeData(for: sleepAnalysisType) {(sample, error) in
//            if (sample != nil){
//                print("Got Sleep")
//            }else{
//                print("Sleep Not Found ")
//            }
//            guard let sample = sample else {
//
//                if let error = error {
//                    self.displayAlert(for: error)
//                }
//                return
//            }
//
//            for each in sample {
//                if let data = each as? HKCategorySample {
//                    print(data)
//                    let inBed = data.value == HKCategoryValueSleepAnalysis.inBed.rawValue
//                    print("inbed:", inBed)
//                    let asleep = data.value == HKCategoryValueSleepAnalysis.asleep.rawValue
//                    print("asleep:", asleep)
//                    let startDate = data.startDate
//                    print("startDate:", startDate)
//                    let endDate = data.endDate
//                    print("endDate:", endDate)
//
//                    let now = NSDate()
//                    let nowTimeStamp: TimeInterval = now.timeIntervalSince1970
//                    let weekAgo = nowTimeStamp - 604800
//                    //604800 one week
//                    //86400 one day
//
//                    let startDateStamp: TimeInterval = startDate.timeIntervalSince1970
//                    let endDateStamp: TimeInterval = endDate.timeIntervalSince1970
//                    if (startDateStamp > weekAgo && endDateStamp > weekAgo) {
//                        let startDateStampString = String(startDateStamp)
//                        let endDateStampString = String(endDateStamp)
//
//                        self.networkController.postSleepData(inBed: inBed, startDate: startDateStampString, endDate: endDateStampString, session_id: self.user.session_id!) {
//                            (status_code) in
//                                if (status_code != nil) {
//                                    print(status_code!)
//                                }
//                        }
//                    }
//                }
//            }
//            let lastSample = sample.last as? HKCategorySample
//            let inBed = lastSample!.value == HKCategoryValueSleepAnalysis.inBed.rawValue
//            let asleep = lastSample!.value == HKCategoryValueSleepAnalysis.asleep.rawValue
//            let sleepStartDate = lastSample!.startDate
//            let sleepEndDate = lastSample!.endDate
//            self.user.inBedTime = inBed
//            self.user.asleepTime = asleep
//            self.user.sleepStart = sleepStartDate
//            self.user.sleepEnd = sleepEndDate
//        }
//    }
//
//    public func loadAndDisplayMostRecentWeight() {
//
//        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
//            print("Body Mass Sample Type is no longer available in HealthKit")
//            return
//        }
//
//        UserController.getMostRecentSample(for: weightSampleType) { (sample, error) in
//
//            if (sample != nil){
//                print("Got Weight")
//            }else{
//                print("Weight Not Found")
//            }
//
//            guard let sample = sample else {
//
//                if let error = error {
//                    self.displayAlert(for: error)
//                }
//                return
//            }
//            let lastsample = sample.last as? HKQuantitySample
//            let weightInKilograms = lastsample!.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
//            self.user.weightInKilograms = weightInKilograms
//        }
//    }
//
//}
