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
                (status_code) in
                    if let status_code = status_code {
                        if status_code == 200 {
                            DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                            }
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
