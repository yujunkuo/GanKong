//
//  RegisterViewController.swift
//  GanKong
//
//  Created by 郭宇雋 on 2020/4/7.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let networkController = NetworkController( )
    
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
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(session_id, forKey: "session_id")
                                self.performSegue(withIdentifier: "RegisterSegue", sender: nil)
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
