//
//  HomeViewController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/3/27.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HealthKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate{
    
    var session_id: String = (UserDefaults.standard.value(forKey: "session_id") as? String)!
    var user = User( )
    
    let locationManager = CLLocationManager( )
    
    let networkController = NetworkController( )
    

//    @IBAction func AuthorizationButtonAction(_ sender: UIButton) {
//        authorizeHealthKit( )
//    }
    
    @IBOutlet var currentLocation: UILabel!
    @IBOutlet var weatherMain: UILabel!
    @IBOutlet var weatherDescription: UILabel!
    @IBOutlet var waterButton: UIButton!
    @IBOutlet var drinkButton: UIButton!
    @IBOutlet var exerciseButton: UIButton!
    @IBOutlet var foodButton: UIButton!

    private func authorizeHealthKit( ) {
        HealthKitAuthorization.authorizeHealthKit { (authorized, error, check) in
        guard authorized else {
          let baseMessage = "HealthKit Authorization Failed"
          if let error = error {
            print("\(baseMessage). Reason: \(error.localizedDescription)")
          } else {
            print(baseMessage)
          }
          return
        }
        print("HealthKit Successfully Authorized.")
      }
    }
    
    @IBOutlet var mainGIFImageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
         if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
             appDelegate.user = self.user
         }
         
         mainGIFImageView.loadGif(name: "bear")
    }
    
    override func viewDidLoad( ) {
        
        super.viewDidLoad( )
        
        user.session_id = self.session_id

        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus( ) == .notDetermined {
            locationManager.requestWhenInUseAuthorization( )
        }
        // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus( ) == .denied {
            let controller = UIAlertController(title: "地點存取權限", message: "我們需要知道您的位置，以提供天氣等資訊...", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus( ) == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation( )
        }
        
        waterButton.isHidden = true
        drinkButton.isHidden = true
        exerciseButton.isHidden = true
        foodButton.isHidden = true

        self.loadAndDisplayAgeSexAndBloodType()
        self.loadAndDisplayMostRecentWeight()
        self.loadAndDisplayMostRecentHeight()
        self.loadAndDisplayMostRecentHeartRate()
        self.loadAndDisplayMostRecentStep()
        self.loadAndDisplayMostRecentSleepAnalysis()
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let now = NSDate()
        let nowTimeStamp: TimeInterval = now.timeIntervalSince1970
        
        if (UserDefaults.standard.value(forKey: "weather_update_time") != nil) {
              let weather_update_time = UserDefaults.standard.value(forKey: "weather_update_time") as! Double
                if nowTimeStamp - Double(weather_update_time) > 3600 {
                self.networkController.getWeatherData(lat: locValue.latitude, lon: locValue.longitude) {
                    (return_dict_list) in
                    let main: String = return_dict_list![0]["main"] as! String
                    let description: String = return_dict_list![0]["description"] as! String
                    print(main)
                    print(description)
                    DispatchQueue.main.async {
                        self.weatherMain.text = "Current Weather: \(main)"
                        self.weatherDescription.text = "Description: \(description)"
                    }
                    UserDefaults.standard.set(main, forKey: "weather_main")
                    UserDefaults.standard.set(description, forKey: "weather_description")
                    UserDefaults.standard.set(nowTimeStamp, forKey: "weather_update_time")
                    }
                }
              else {
                DispatchQueue.main.async {
                    self.weatherMain.text = "Current Weather: \( UserDefaults.standard.value(forKey: "weather_main")!)"
                    self.weatherDescription.text = "Description: \( UserDefaults.standard.value(forKey: "weather_description")!)"
                    }
                print("last update time: \(weather_update_time)")
            }
        }
        else {
            self.networkController.getWeatherData(lat: locValue.latitude, lon: locValue.longitude) {
                (return_dict_list) in
                    let main: String = return_dict_list![0]["main"] as! String
                    let description: String = return_dict_list![0]["description"] as! String
                    print(main)
                    print(description)
                    DispatchQueue.main.async {
                        self.weatherMain.text = "Current Weather: \(main)"
                        self.weatherDescription.text = "Description: \(description)"
                    }
                    UserDefaults.standard.set(main, forKey: "weather_main")
                    UserDefaults.standard.set(description, forKey: "weather_description")
                    UserDefaults.standard.set(nowTimeStamp, forKey: "weather_update_time")
            }
        }
        
        guard let location: CLLocation = manager.location else { print("error"); return }
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            DispatchQueue.main.async {
                self.currentLocation.text = "Location: \(city), \(country)"
            }
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ( )) {
        CLGeocoder( ).reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    @IBAction func popFood(_ sender: UIButton) {
            let imagePicker = UIImagePickerController( )
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let image = pickedImage
            guard let base64String = image.jpegData(compressionQuality: 0.2)?.base64EncodedString( ) else {
                print("Could not get JPEG or base64 representation of UIImage")
                return
            }
            networkController.postFoodData(base64String: base64String)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    var drinkCount = 0
    @IBAction func popAquaBt(_ sender: Any){
        if drinkCount == 0{
            waterButton.isHidden = false
            drinkButton.isHidden = false
            exerciseButton.isHidden = false
            foodButton.isHidden = false
            drinkCount = 1
        }
        else{
            waterButton.isHidden = true
            drinkButton.isHidden = true
            exerciseButton.isHidden = true
            foodButton.isHidden = true
            drinkCount = 0
        }
    }
    
    @IBAction func popExcercise(_ sender: Any){
        let exercisePopVC = storyboard?.instantiateViewController(withIdentifier: "ExercisePopoverViewController") as! ExercisePopoverViewController
        exercisePopVC.preferredContentSize = CGSize(width: 10, height: 10)
        let navController = UINavigationController(rootViewController: exercisePopVC)
        navController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popOver = navController.popoverPresentationController
        popOver?.delegate = self
        popOver?.barButtonItem = sender as? UIBarButtonItem
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func popDrink(_ sender: Any){
        let drinkPopVC = storyboard?.instantiateViewController(withIdentifier: "DrinkPopoverViewController") as! DrinkPopoverViewController
        drinkPopVC.preferredContentSize = CGSize(width: 10, height: 10)
        let navController = UINavigationController(rootViewController: drinkPopVC)
        navController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popOver = navController.popoverPresentationController
        popOver?.delegate = self
        popOver?.barButtonItem = sender as? UIBarButtonItem
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func popWater(_ sender: Any){
        let waterPopVC = storyboard?.instantiateViewController(withIdentifier: "WaterPopoverViewController") as! WaterPopoverViewController
        waterPopVC.preferredContentSize = CGSize(width: 10, height: 10)
        let navController = UINavigationController(rootViewController: waterPopVC)
        navController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popOver = navController.popoverPresentationController
        popOver?.delegate = self
        popOver?.barButtonItem = sender as? UIBarButtonItem
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle{
        return .none
    }
    
    public func loadAndDisplayAgeSexAndBloodType() {
        do {
            let userAgeSexAndBloodType = try UserController.getAgeSexAndBloodType()
            user.age = userAgeSexAndBloodType.age
            user.biologicalSex = userAgeSexAndBloodType.biologicalSex
            user.bloodType = userAgeSexAndBloodType.bloodType
        } catch let error {
            self.displayAlert(for: error)
        }
    }

    public func loadAndDisplayMostRecentHeight() {

        //1. Use HealthKit to create the Height Sample Type
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Height Object Type is no longer available in HealthKit")
            return
        }

        UserController.getMostRecentSample(for: heightSampleType) { (sample, error) in

            if (sample != nil){
                print("Got Height")
            }else{
                print("Height Not Found")
            }

            guard let sample = sample else {

                if let error = error {
                    self.displayAlert(for: error)
                }

                return
            }

            //2. Convert the height sample to meters, save to the profile model,
            //   and update the user interface.
            let lastsample = sample.last as? HKQuantitySample
            let heightInMeters = lastsample!.quantity.doubleValue(for: HKUnit.meter())
            self.user.heightInMeters = heightInMeters
        }
    }

    public func loadAndDisplayMostRecentHeartRate() {

        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Heart Rate Sample Type is no longer available in HealthKit")
            return
        }

        UserController.getMostRecentSample(for: heartRateType) { (sample, error) in

            if (sample != nil){
                print("Got HR")
            }else{
                print("HR Found")
            }

            guard let sample = sample else {

                if let error = error {
                    self.displayAlert(for: error)
                }
                return
            }
            let lastsample = sample.last as? HKQuantitySample
            let heartRate = HKUnit(from: "count/min")
            let heartRateperMins = lastsample!.quantity.doubleValue(for: heartRate)
            self.user.heartRatePerMins = heartRateperMins
            let HRdate = lastsample!.startDate
            print(type(of: HRdate))
            self.user.heartRateDate = HRdate

            let now = NSDate()
            let nowTimeStamp: TimeInterval = now.timeIntervalSince1970
            let weekAgo = nowTimeStamp - 604800
            // 604800 one week
            // 86400 one day
            for each in sample{
                let each = each as? HKQuantitySample
                let eachHRdate = each!.startDate
                let HRtimeStamp: TimeInterval = eachHRdate.timeIntervalSince1970
                if (HRtimeStamp > weekAgo){
                    let HRtimeStampString = String(HRtimeStamp)
                    let eachheartRateperMins = each!.quantity.doubleValue(for: heartRate)
                    let heartRateFormatter = NumberFormatter()
                    let heartRateData = heartRateFormatter.string(for: eachheartRateperMins)

                    self.networkController.postHeartRateData(data: heartRateData!, time: HRtimeStampString, session_id: self.user.session_id!) {
                        (status_code) in
                        if (status_code != nil) {
                            print(status_code!)
                        }
                    }
                }
            }
        }
    }

    public func loadAndDisplayMostRecentStep() {

        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print("Step Count Sample Type is no longer available in HealthKit")
            return
        }

        UserController.getMostRecentSample(for: stepCountType) { (sample, error) in

            if (sample != nil){
                print("Got Step")
            }else{
                print("Step Not Found")
            }

            guard let sample = sample else {

                if let error = error {
                    self.displayAlert(for: error)
                }
                return
            }
            let lastsample = sample.last as? HKQuantitySample
            let stepCount = HKUnit(from: "count")
            let stepCountDouble = lastsample!.quantity.doubleValue(for: stepCount)
            self.user.stepCount = Int(stepCountDouble)
            let SCdate = lastsample!.startDate
            self.user.stepCountDate = SCdate

            let now = NSDate()
            let nowTimeStamp: TimeInterval = now.timeIntervalSince1970
            let weekAgo = nowTimeStamp - 604800
            //604800 one week
            //86400 one day
            for each in sample{
                let each = each as? HKQuantitySample
                let eachSCdate = each!.startDate
                let SCtimeStamp: TimeInterval = eachSCdate.timeIntervalSince1970
                if(SCtimeStamp > weekAgo){
                    let SCtimeStampString = String(SCtimeStamp)

                    let eachstepCountDouble = each!.quantity.doubleValue(for: stepCount)
                    let stepCountFormatter = NumberFormatter()
                    let stepCountData = stepCountFormatter.string(for: eachstepCountDouble)

                    self.networkController.postStepCountData(data: stepCountData!, time: SCtimeStampString, session_id: self.user.session_id!) {
                        (status_code) in
                            if (status_code != nil) {
                                print(status_code!)
                            }
                    }
                }
            }
        }
    }

    public func loadAndDisplayMostRecentSleepAnalysis() {
        guard let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) else {
            print("Sleep Analysis Sample Type is no longer available in HealthKit")
            return
        }

        UserController.getCategoryTypeData(for: sleepAnalysisType) {(sample, error) in
            if (sample != nil){
                print("Got Sleep")
            }else{
                print("Sleep Not Found ")
            }
            guard let sample = sample else {

                if let error = error {
                    self.displayAlert(for: error)
                }
                return
            }

            for each in sample {
                if let data = each as? HKCategorySample {
                    print(data)
                    let inBed = data.value == HKCategoryValueSleepAnalysis.inBed.rawValue
                    print("inbed:", inBed)
                    let asleep = data.value == HKCategoryValueSleepAnalysis.asleep.rawValue
                    print("asleep:", asleep)
                    let startDate = data.startDate
                    print("startDate:", startDate)
                    let endDate = data.endDate
                    print("endDate:", endDate)

                    let now = NSDate()
                    let nowTimeStamp: TimeInterval = now.timeIntervalSince1970
                    let weekAgo = nowTimeStamp - 604800
                    //604800 one week
                    //86400 one day

                    let startDateStamp: TimeInterval = startDate.timeIntervalSince1970
                    let endDateStamp: TimeInterval = endDate.timeIntervalSince1970
                    if (startDateStamp > weekAgo && endDateStamp > weekAgo) {
                        let startDateStampString = String(startDateStamp)
                        let endDateStampString = String(endDateStamp)

                        self.networkController.postSleepData(inBed: inBed, startDate: startDateStampString, endDate: endDateStampString, session_id: self.user.session_id!) {
                            (status_code) in
                                if (status_code != nil) {
                                    print(status_code!)
                                }
                        }
                    }
                }
            }
            let lastSample = sample.last as? HKCategorySample
            let inBed = lastSample!.value == HKCategoryValueSleepAnalysis.inBed.rawValue
            let asleep = lastSample!.value == HKCategoryValueSleepAnalysis.asleep.rawValue
            let sleepStartDate = lastSample!.startDate
            let sleepEndDate = lastSample!.endDate
            self.user.inBedTime = inBed
            self.user.asleepTime = asleep
            self.user.sleepStart = sleepStartDate
            self.user.sleepEnd = sleepEndDate
        }
    }

    public func loadAndDisplayMostRecentWeight() {

        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }

        UserController.getMostRecentSample(for: weightSampleType) { (sample, error) in

            if (sample != nil){
                print("Got Weight")
            }else{
                print("Weight Not Found")
            }

            guard let sample = sample else {

                if let error = error {
                    self.displayAlert(for: error)
                }
                return
            }
            let lastsample = sample.last as? HKQuantitySample
            let weightInKilograms = lastsample!.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            self.user.weightInKilograms = weightInKilograms
        }
    }

    private func displayAlert(for error: Error) {

        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "O.K.",
                                      style: .default,
                                      handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
