//
//  UserTableViewController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/3/27.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit
import HealthKit

class UserTableViewController: UITableViewController {
    
    override func viewDidLoad( ) {
        super.viewDidLoad( )
        updateHealthInfo( )

    }
    
    let networkController = NetworkController( )
    
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var biologicalSexLabel: UILabel!
    @IBOutlet var bloodTypeLabel: UILabel!
    @IBOutlet var stepLabel: NSLayoutConstraint!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var bodyMassIndexLabel: UILabel!
    @IBOutlet var heartrateLabel: UILabel!
    @IBOutlet var HRDateLabel: UILabel!
    

    private enum ProfileSection: Int {
            case ageSexBloodType
            case weightHeightBMI
            case readHealthKitData
            case saveBMI
        }
        
    private enum ProfileDataError: Error {
            
            case missingBodyMassIndex
            
            var localizedDescription: String {
                switch self {
                case .missingBodyMassIndex:
                    return "Unable to calculate body mass index with available profile data."
                }
            }
        }
        
    private let user = User( )
        
    private func updateHealthInfo() {
        loadAndDisplayAgeSexAndBloodType()
        loadAndDisplayMostRecentWeight()
        loadAndDisplayMostRecentHeight()
        loadAndDisplayMostRecentHeartRate()
    }
        
    private func loadAndDisplayAgeSexAndBloodType() {
        do {
            let userAgeSexAndBloodType = try UserController.getAgeSexAndBloodType()
            user.age = userAgeSexAndBloodType.age
            user.biologicalSex = userAgeSexAndBloodType.biologicalSex
            user.bloodType = userAgeSexAndBloodType.bloodType
            updateLabels()
        } catch let error {
            self.displayAlert(for: error)
        }
    }
        
    private func updateLabels() {
        if let age = user.age {
            ageLabel.text = "\(age)"
        }
        
        if let biologicalSex = user.biologicalSex {
            biologicalSexLabel.text = String(biologicalSex.rawValue)
        }
        
        if let bloodType = user.bloodType {
            bloodTypeLabel.text = String(bloodType.rawValue)
        }
        
        if let weight = user.weightInKilograms {
            let weightFormatter = MassFormatter()
            weightFormatter.isForPersonMassUse = true
            weightLabel.text = weightFormatter.string(fromKilograms: weight)
        }
        
        if let height = user.heightInMeters {
            let heightFormatter = LengthFormatter()
            heightFormatter.isForPersonHeightUse = true
            heightLabel.text = heightFormatter.string(fromMeters: height)
        }
        
        if let bodyMassIndex = user.bodyMassIndex {
            bodyMassIndexLabel.text = String(format: "%.02f", bodyMassIndex)
        }
        
        if let heartrate = user.heartratePerMins {
            let heartrateFormatter = NumberFormatter()
            heartrateLabel.text = heartrateFormatter.string(for: heartrate)
        }
        
        if let HRDate = user.HeartRateDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd a hh:mm:ss"
            self.HRDateLabel.text = dateFormatter.string(from: HRDate)
        }
        
    }
        
    private func loadAndDisplayMostRecentHeight() {
        
        //1. Use HealthKit to create the Height Sample Type
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Height Object Type is no longer available in HealthKit")
            return
        }
        
        UserController.getMostRecentSample(for: heightSampleType) { (sample, error) in
            
            guard let sample = sample else {
                
                if let error = error {
                    self.displayAlert(for: error)
                }
                
                return
            }
                
            //2. Convert the height sample to meters, save to the profile model,
            //   and update the user interface.
            let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            self.user.heightInMeters = heightInMeters
            self.updateLabels()
        }
        
        
    }
        
    private func loadAndDisplayMostRecentWeight() {
        
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        
        UserController.getMostRecentSample(for: weightSampleType) { (sample, error) in
            
            guard let sample = sample else {
                
                if let error = error {
                    self.displayAlert(for: error)
                }
                return
            }
            
            let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            self.user.weightInKilograms = weightInKilograms
            self.updateLabels()
        }
        
    }
        
    private func loadAndDisplayMostRecentHeartRate() {
        
        guard let heartrateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Heart Rate Sample Type is no longer available in HealthKit")
            return
        }
        
        UserController.getMostRecentSample(for: heartrateType) { (sample, error) in
            
            guard let sample = sample else {
                
                if let error = error {
                    self.displayAlert(for: error)
                }
                return
            }
            let heartrate = HKUnit(from: "count/min")
            let heartrateperMins = sample.quantity.doubleValue(for: heartrate)
            self.user.heartratePerMins = heartrateperMins
            let HRdate = sample.startDate
            self.user.HeartRateDate = HRdate
            self.updateLabels()
            let HRtimeStamp: TimeInterval = HRdate.timeIntervalSince1970
            let HRtimeStampString = String(HRtimeStamp)
            
            let heartrateFormatter = NumberFormatter()
            let heart_rate_data = heartrateFormatter.string(for: heartrateperMins)
        
            self.networkController.postHeartRateData(data: heart_rate_data!, time: HRtimeStampString) { (response) in
                
              }
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
    
    
    // MARK: - Table view data source

    //override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
     //   return 1
    //}

    //override func tableView(_ tableView: UITableView, numberOfRowsInSection //section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
     //   return 4
   //}

    
    //override func tableView(_ tableView: UITableView, cellForRowAt indexPath: //IndexPath) -> UITableViewCell {
     //   let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: //indexPath)

        // Configure the cell...
      //  let information = userInformation[indexPath.row]
    //    cell.textLabel?.text = "\(information)"
     //   return cell
    //}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
