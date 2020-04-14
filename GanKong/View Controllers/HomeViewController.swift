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

class HomeViewController: UIViewController {
    
    var session_id: String = String((UserDefaults.standard.value(forKey: "session_id") as? String)!)
    var user = User( )
    
    let locationManager = CLLocationManager()
    

    @IBAction func AuthorizationButtonAction(_ sender: UIButton) {
        authorizeHealthKit( )
    }

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
    
    override func viewDidLoad( ) {
        super.viewDidLoad( )
        user.session_id = self.session_id

        // Do any additional setup after loading the view.
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
