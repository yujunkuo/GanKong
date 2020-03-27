//
//  UserTableViewController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/3/27.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    private var user = User( )
    private var userInformation: [Any] = [ ]

    private func loadAgeSexAndBloodType( ) {
      do {
        let userAgeSexAndBloodType = try UserController.getAgeSexAndBloodType()
        user.age = userAgeSexAndBloodType.age
        user.sex = userAgeSexAndBloodType.biologicalSex
        user.bloodType = userAgeSexAndBloodType.bloodType
      } catch _ {
      }
    }
    
    
    override func viewDidLoad( ) {
        super.viewDidLoad( )
        loadAgeSexAndBloodType( )
        if let name = user.name {
            userInformation.append(["姓名": name])
        } else { userInformation.append(["姓名": "NaN"]) }
        if let age = user.age {
            userInformation.append( ["年齡": age] )
        } else { userInformation.append(["年齡": "NaN"]) }
        if let sex = user.sex {
            userInformation.append(["性別": sex])
        } else { userInformation.append(["性別": "NaN"]) }
        if let bloodType = user.bloodType {
            userInformation.append(["血型": bloodType])
        } else { userInformation.append(["血型": "NaN"]) }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath)

        // Configure the cell...
        let information = userInformation[indexPath.row]
        cell.textLabel?.text = "\(information)"
        return cell
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
