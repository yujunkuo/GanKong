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
    
    var user = User()
    
    override func viewDidLoad( ) {
        super.viewDidLoad( )
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.user = appDelegate.user
        }
        user.session_id = String((UserDefaults.standard.value(forKey: "session_id") as? String)!)
        updateHealthInfo( )
    }
    
    let networkController = NetworkController( )
    
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var biologicalSexLabel: UILabel!
    @IBOutlet var bloodTypeLabel: UILabel!
    @IBOutlet var stepCountLabel: UILabel!
    @IBOutlet var SCDateLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var bodyMassIndexLabel: UILabel!
    @IBOutlet var heartRateLabel: UILabel!
    @IBOutlet var HRDateLabel: UILabel!
    @IBOutlet var sleepStartLabel: UILabel!
    @IBOutlet var sleepEndLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBAction func logoutButton(_ sender: UIButton) {
        self.networkController.logout(session_id: self.user.session_id!) {
            (status_code) in
            print(self.user.session_id!) // debug
            if let status_code = status_code {
                if status_code == 200 {
                    print(UserDefaults.standard.value(forKey: "session_id")) // debug
                    UserDefaults.standard.removeObject(forKey: "session_id")
                    print(UserDefaults.standard.value(forKey: "session_id")) // debug
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "LogoutSegue", sender: nil)
                    }
                }
                else {
                    print("logout fail")
                }
            }
            else {
                print("error")
            }
        }
    }
    
    
    
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
    
    private func updateHealthInfo() {
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
        
        if let heartRate = user.heartRatePerMins {
            let heartRateFormatter = NumberFormatter()
            heartRateLabel.text = heartRateFormatter.string(for: heartRate)
        }
        
        if let HRDate = user.heartRateDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd a hh:mm:ss"
            self.HRDateLabel.text = dateFormatter.string(from: HRDate)
        }
        
        
        if let stepCount = user.stepCount {
            let stepCountFormatter = NumberFormatter()
            stepCountLabel.text = stepCountFormatter.string(for: stepCount)
        }
        
        if let SCDate = user.stepCountDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd a hh:mm:ss"
            self.SCDateLabel.text = dateFormatter.string(from: SCDate)
        }
        
        if let sleepStartDate = user.sleepStart {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd a hh:mm:ss"
            self.sleepStartLabel.text = dateFormatter.string(from: sleepStartDate)
        }
        
        if let sleepEndDate = user.sleepEnd {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd a hh:mm:ss"
            self.sleepEndLabel.text = dateFormatter.string(from: sleepEndDate)
        }
    }
    
    
    
    // MARK: - Table view data source
    
    //override func numberOfSections(in tableView: UITableView) -> Int {
    // warning Incomplete implementation, return the number of sections
    // return
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
