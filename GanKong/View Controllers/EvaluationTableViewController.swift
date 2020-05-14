//
//  EvaluationTableViewController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/3/27.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit
import Foundation
import GooglePlaces
import Alamofire

class EvaluationTableViewController: UITableViewController{
    var bodyindexes: [ BodyIndex ] = [
        BodyIndex(name: "Heart Rate", symbol: "-❤️" ),
        BodyIndex(name: "Sleep", symbol: "-😴" )
    ]
    
    var placesClient = GMSPlacesClient.shared()
    var nearbyPlaces:[Location] = []
    var keyCount = 0
    
    func requestNearbyLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: Float) {
        
        let key = "AIzaSyCBabIKFA2_WgOIB6AdYh_5ofZau6ttN3Q"
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&key=\(key)"
        
        print(urlString)
        
        fetchRequestHandler(urlString: urlString)
    }
    
    func fetchRequestHandler(urlString: String){
        nearbyPlaces.removeAll()
        
        let APIurl = urlString
        
        Alamofire.request(APIurl).responseJSON(completionHandler: {response in
            let responseJson = response.result.value
            guard let localJson = responseJson as? [String: Any],
                let status = localJson["status"] as? String else {
                    print("No Status")
                    return
            }
            if (status == "OVER_QUERY_LIMIT" || status == "INVALID_REQUEST"){
                print("here")
                if self.keyCount < 4{
                    self.keyCount += 1
                    self.fetchRequestHandler(urlString: "")
                }
                else{
                    self.keyCount = 0
                    self.fetchRequestHandler(urlString: "")
                }
            }
            
            guard let results = localJson["results"] as? [[String: Any]] else{
                return
            }
            
            if results.count == 0 {
                print("No data inside")
                return
            }
            
            var photoReference = ""
            var rating = -1.0
            
            
            for result in results{
                let types = result["types"] as? [String]
                if (types!.contains("restaurant") || types!.contains("food")){
                    if result["photos"] != nil{
                        guard
                            let photos = result["photos"] as? [[String: Any]],
                            let reference = photos[0]["photo_reference"] as? String else {
                                return
                        }
                        photoReference = reference
                    }
                    
                    if result["rating"] != nil {
                        
                        guard let rlevel = result["rating"] as? Double else {
                            return
                        }
                        rating = rlevel
                    }
                    
                    guard
                        let geometry = result["geometry"] as? [String:Any],
                        let id = result["id"] as? String,
                        let name = result["name"] as? String,
                        let placeId = result["place_id"] as? String,
                        let openingHours = result["opening_hours"] as? [String:Any],
                        let location = geometry["location"] as? [String:Any],
                        let latitude = location["lat"] as? CLLocationDegrees,
                        let longitude = location["lng"] as? CLLocationDegrees,
                        let vicinity = result["vicinity"] as? String else {
                            return
                    }
                    
                    let locationData = Location(latitude: latitude,
                                                longitude: longitude,
                                                name: name,
                                                placeId: placeId,
                                                openingHours: openingHours,
                                                rating: rating,
                                                types: types!,
                                                photoReference: photoReference,
                                                vicinity: vicinity)
                    
                    print(locationData.name)
                    print(locationData.vicinity)
                    self.nearbyPlaces.append(locationData)
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let latitude = UserDefaults.standard.value(forKey: "latitude")
        let longitude = UserDefaults.standard.value(forKey: "longitude")
        
        requestNearbyLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees, radius: 1000.0)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyPlaces.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BodyIndexCell", for: indexPath)
        
        // Configure the cell...
        let nearbyPlace = nearbyPlaces[indexPath.row]
        cell.textLabel?.text = nearbyPlace.name
        cell.detailTextLabel?.text = nearbyPlace.vicinity
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "EvaluationSegue" {
            let evaluationDetailViewController = segue.destination as!
            EvaluationDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            evaluationDetailViewController.bodyIndexType = bodyindexes[index].name
        }
    }
    
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
