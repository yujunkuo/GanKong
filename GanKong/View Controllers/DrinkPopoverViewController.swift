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
    
    let drinks = ["🍵(單茶)", "🥤(奶茶)", "☕️(咖啡)", "🍹(果汁)"]
    let drink_dict:Dictionary = ["🍵(單茶)" : "單茶", "🥤(奶茶)" : "奶茶",
                                 "☕️(咖啡)" : "咖啡", "🍹(果汁)" : "果汁"]
    let drink_volumne = ["咖啡小杯(240 c.c.)", "咖啡中杯(360 c.c.)", "咖啡大杯(480 c.c.)",  "小杯(500 c.c)", "大杯(700 c.c.)"]
    let volumne_dict:Dictionary = ["咖啡小杯(240 c.c.)":240.0, "咖啡中杯(360 c.c.)":360.0, "咖啡大杯(480 c.c.)":480.0, "小杯(500 c.c)":500.0, "大杯(700 c.c.)":700.0]
    // 茶每 700 毫升 100 大卡，奶類 700 毫升 390 大卡，果汁 100 毫升 50 大卡
    // 咖啡 100 毫升 4.2 大卡
    let calories_dict:Dictionary = ["單茶":0.142857, "奶茶":0.557142, "咖啡":0.042, "果汁":0.05]
    
    func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    let drinkPickerView = UIPickerView()
    @IBOutlet var drinkSelectField: UITextField!
    let volumnePickerView = UIPickerView()
    @IBOutlet var volumneSelectField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinkPickerView.delegate = self
        drinkPickerView.dataSource = self
        
        drinkSelectField.inputView = drinkPickerView
        drinkSelectField.placeholder = "Select Drink"
        drinkSelectField.textAlignment = .center
        
        volumnePickerView.delegate = self
        volumnePickerView.dataSource = self
        
        volumneSelectField.inputView = volumnePickerView
        volumneSelectField.placeholder = "Select Volumne"
        volumneSelectField.textAlignment = .center
        
        self.view.addSubview(drinkSelectField)
        self.view.addSubview(volumneSelectField)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            // 返回陣列 drinks 的成員數量
            return drinks.count
        }
        
        // 否則就是設置第二列
        // 返回陣列 drink_volumne 的成員數量
        return drink_volumne.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            // 設置為陣列 drinks 的第 row 項資料
            return drinks[row]
        }
        
        // 否則就是設置第二列
        // 設置為陣列 drink_volumne 的第 row 項資料
        return drink_volumne[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            drinkSelectField.text = drinks[row]
            drinkSelectField.resignFirstResponder()
        }else{
            volumneSelectField.text = drink_volumne[row]
            volumneSelectField.resignFirstResponder()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any){
        if(drinkSelectField.text != "" && volumneSelectField.text != ""){
            let drinkType = drink_dict[String(drinkSelectField.text!)]!
            let volumne = volumne_dict[String(volumneSelectField.text!)]!
            let calories:Double = calories_dict[drinkType]! * volumne
            print(drinkType, volumne)
            print("共攝取" + String(ceil(calories)) + "大卡")
            
            self.dismiss(animated: true, completion: nil)
        }
        else if(drinkSelectField.text == ""){
            let controller = UIAlertController(title: "飲品類別為空值", message: "請輸入飲品類別", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        else{
            let controller = UIAlertController(title: "飲品容量為空值", message: "請輸入飲品容量", preferredStyle: .alert)
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
