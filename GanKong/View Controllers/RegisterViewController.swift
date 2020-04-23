//
//  RegisterViewController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/4/7.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit
import HealthKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let networkController = NetworkController( )
    
    var authCheck = false
    
    @IBOutlet var accountInput: UITextField!
    @IBOutlet var passwordInput: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder( )
        return true
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        self.networkController.register(account: accountInput.text!, password: passwordInput.text!) {
                (return_list) in
                if let status_code = return_list?[0],
                    let session_id = return_list?[1]{
                        if status_code as! Int == 200 {
                            if (self.authCheck == true) {
                                DispatchQueue.main.async {
                                    UserDefaults.standard.set(session_id, forKey: "session_id")
                                    self.performSegue(withIdentifier: "RegisterSegue", sender: nil)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    UserDefaults.standard.set(session_id, forKey: "session_id")
                                    self.performSegue(withIdentifier: "RegisterNotAuthSegue", sender: nil)
                                }
                            }
                        } else {
                            print(status_code)
                            DispatchQueue.main.async {
                                self.errorLabel.isHidden = false
                            }
                        }
                    }
                    else {
                        print("error")
                    }
        }
    }
    
    
    private func authorizeHealthKit( ) {
        HealthKitAuthorization.authorizeHealthKit { (authorized, error, check) in
        guard authorized else {
          let baseMessage = "HealthKit Authorization Failed"
          if let error = error {
            print("\(baseMessage). Reason: \(error.localizedDescription)")
          } else {
            print(baseMessage)
          }
          if check {
            self.authCheck = true
          } else {
            self.authCheck = false
          }
          return
        }
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
