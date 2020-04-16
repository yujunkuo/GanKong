//
//  DrinkPopoverViewController.swift
//  GanKong
//
//  Created by 施君諺 on 2020/4/16.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit

class DrinkPopoverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let fullScreenSize = UIScreen.main.bounds.size
    
    let drinks = ["💧（水）", "🍵(單茶)", "🥤(奶茶)", "☕️(咖啡)", "🍹(果汁)"]
    let drink_dict:Dictionary = ["💧（水）" : "水", "🍵(單茶)" : "單茶", "🥤(奶茶)" : "奶茶",
                                 "☕️(咖啡)" : "咖啡", "🍹(果汁)" : "果汁"]
    
    func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    let drinkPickerView = UIPickerView()
    @IBOutlet var drinkSelectField: UITextField!
//    let numPickerView = UIPickerView()
//    @IBOutlet var numSelectField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinkPickerView.delegate = self
        drinkPickerView.dataSource = self
        
        drinkSelectField.inputView = drinkPickerView
        drinkSelectField.placeholder = "Select Drink"
        drinkSelectField.textAlignment = .center

        self.view.addSubview(drinkSelectField)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drinks[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        drinkSelectField.text = drinks[row]
        drinkSelectField.resignFirstResponder()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any){
        if(drinkSelectField.text != ""){
            print(drink_dict[String(drinkSelectField.text!)]!)
            self.dismiss(animated: true, completion: nil)
        }else{
            let controller = UIAlertController(title: "飲品類別為空值", message: "請輸入飲品類別", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
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
