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

class HomeViewController: UIViewController, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var session_id: String = String((UserDefaults.standard.value(forKey: "session_id") as? String)!)
    var user = User( )
    
    let locationManager = CLLocationManager( )
    
    let networkController = NetworkController( )
    

    @IBAction func AuthorizationButtonAction(_ sender: UIButton) {
        authorizeHealthKit( )
    }
    
    @IBOutlet var currentLocation: UILabel!
    @IBOutlet var weatherMain: UILabel!
    @IBOutlet var weatherDescription: UILabel!
    

    private func authorizeHealthKit( ) {
        HealthKitAuthorization.authorizeHealthKit { (authorized, error) in
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
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
