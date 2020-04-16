//
//  LoginViewController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/4/7.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    let networkController = NetworkController( )
    
    var session_id: String = "Nil"
    
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
    
    @IBAction func loginButton(_ sender: UIButton) {
        self.networkController.login(account: accountInput.text!, password: passwordInput.text!) {
                (return_list) in
                if let status_code = return_list?[0],
                    let session_id = return_list?[1]{
                        if status_code as! Int == 200 {
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(session_id, forKey: "session_id")
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
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    let tabBarController = segue.destination as! UITabBarController
    //    let navController = tabBarController.viewControllers?.first as?
     //        UINavigationController
     //   let homeVC = navController?.viewControllers.first as?
    //         HomeViewController
    //    homeVC?.session_id = session_id
   // }
    
    
    override func viewDidLoad( ) {
        super.viewDidLoad( )
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // auto login
        print("Appear")
        if (UserDefaults.standard.value(forKey: "session_id") != nil) {
            session_id = UserDefaults.standard.value(forKey: "session_id") as! String
            self.networkController.checkLogin(session_id: session_id) {
                (status_code) in
                if (status_code != nil) {
                    print(status_code!)
                }
                if status_code == 200 {
                    DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                    }
                } else {
                    print("session is not avalible")
                }
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
