//
//  LoginViewController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/4/7.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let networkController = NetworkController( )
    
    @IBOutlet var accountInput: UITextField!
    @IBOutlet var passwordInput: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBAction func loginButton(_ sender: UIButton) {
        self.networkController.login(account: accountInput.text!, password: passwordInput.text!) {
                (return_list) in
                if let status_code = return_list?[0],
                    let session_id = return_list?[1]{
                    if status_code as! Int == 200 {
                            DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                            }
                            UserDefaults.standard.set(session_id, forKey: "session_id")
                        }
                        else {
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad( )
        // auto login
        if (UserDefaults.standard.value(forKey: "session_id") != nil) {
            let session_id = UserDefaults.standard.value(forKey: "session_id")
            DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
        }
    }
        // Do any additional setup after loading the view.
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
