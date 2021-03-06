//
//  EvaluationDetailViewController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/3/27.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit
import HealthKit
import GooglePlaces

class EvaluationDetailViewController: UIViewController {
    
    var bodyIndexType: String!
    var nearbyPlacesType: String!
    let networkController = NetworkController( )
    var heartRateDatas = [Double]( )
    
    @IBOutlet var dataLabel: UILabel!
    
    private let userHealthProfile = User( )
    
    
    override func viewDidLoad( ) {
        super.viewDidLoad( )

        networkController.fetchHeartRateData { (heartRateData) in
                  if let heartRateData = heartRateData {
                    self.updateUI(with: heartRateData)
                  }
                }
        
//        nearbyPlaces = networkController.getNearby(lat: latitude as! CLLocationDegrees, lng: longitude as! CLLocationDegrees)
    }
    
    func updateUI(with heartRateData: [Double]) {
          DispatchQueue.main.async {
            self.heartRateDatas = heartRateData
            for each in heartRateData {
                self.dataLabel.text! = self.dataLabel.text! + String(Int(each)) + " "
            }
          }
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
