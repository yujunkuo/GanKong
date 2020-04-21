//
//  DrinkPopoverViewController.swift
//  GanKong
//
//  Created by 施君諺 on 2020/4/16.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit

class DrinkPopoverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var user = User( )
    
    let helper = HelperController()
    let networkController = NetworkController( )
    
    let fullScreenSize = UIScreen.main.bounds.size
    
    var typeChoose:[Int] = [0, 0, 0, 0]
    let drinks = ["🍵(單茶)", "🥤(奶茶)", "☕️(咖啡)", "🍹(果汁)"]
    let drink_dict:Dictionary = ["🍵(單茶)" : "單茶", "🥤(奶茶)" : "奶茶",
                                 "☕️(咖啡)" : "咖啡", "🍹(果汁)" : "果汁"]
    let drink_volume = ["小杯(500 c.c)", "大杯(700 c.c.)"]
    let coffee_volume = ["咖啡小杯(240 c.c.)", "咖啡中杯(360 c.c.)", "咖啡大杯(480 c.c.)"]
    let volume_dict:Dictionary = ["咖啡小杯(240 c.c.)":240.0, "咖啡中杯(360 c.c.)":360.0, "咖啡大杯(480 c.c.)":480.0, "小杯(500 c.c)":500.0, "大杯(700 c.c.)":700.0]
    // 茶每 700 毫升 100 大卡，奶類 700 毫升 390 大卡，果汁 100 毫升 50 大卡
    // 咖啡 100 毫升 4.2 大卡
    let calories_dict:Dictionary = ["單茶":0.142857, "奶茶":0.557142, "咖啡":0.042, "果汁":0.05]
    
    func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBOutlet var teaButton: UIButton!
    @IBOutlet var milkButton: UIButton!
    @IBOutlet var coffeeButton: UIButton!
    @IBOutlet var juiceButton: UIButton!
    
    let volumePickerView = UIPickerView()
    @IBOutlet var volumeSelectField: UITextField!
    let datePickerView = UIDatePicker()
    @IBOutlet var dateField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.session_id = String((UserDefaults.standard.value(forKey: "session_id") as? String)!)
        
        teaButton.backgroundColor = UIColor.blue
        milkButton.backgroundColor = UIColor.blue
        coffeeButton.backgroundColor = UIColor.blue
        juiceButton.backgroundColor = UIColor.blue
        
        volumePickerView.delegate = self
        volumePickerView.dataSource = self
        
        volumeSelectField.inputView = volumePickerView
        volumeSelectField.placeholder = "Please choose drink type first"
        volumeSelectField.textAlignment = .center
        
        datePickerView.datePickerMode = .date
        datePickerView.date = Date()
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        datePickerView.locale = Locale(identifier: "zh_TW")
        
        datePickerView.addTarget(self, action: #selector(DrinkPopoverViewController.datePickerChanged), for: .valueChanged)
        
        dateField.inputView = datePickerView
        dateField.placeholder = "Select Date"
        dateField.textAlignment = .center
        
        //        self.view.addSubview(drinkSelectField)
        self.view.addSubview(volumeSelectField)
        self.view.addSubview(dateField)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if typeChoose == [0, 0, 1, 0]{
            return coffee_volume.count
        }
        else if typeChoose == [0, 0, 0, 0]{
            return 0
        }
        else{
            return drink_volume.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if typeChoose == [0, 0, 1, 0]{
            return coffee_volume[row]
        }
        else if typeChoose == [0, 0, 0, 0]{
            return nil
        }
        else{
            return drink_volume[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if typeChoose == [0, 0, 1, 0]{
            volumeSelectField.text = coffee_volume[row]
            volumeSelectField.resignFirstResponder()
        }
        else if typeChoose == [0, 0, 0, 0]{
        }
        else{
            volumeSelectField.text = drink_volume[row]
            volumeSelectField.resignFirstResponder()
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func teaPressed(_ sender: Any){
        typeChoose = [1, 0, 0, 0]
        teaButton.backgroundColor = UIColor.green
        milkButton.backgroundColor = UIColor.blue
        coffeeButton.backgroundColor = UIColor.blue
        juiceButton.backgroundColor = UIColor.blue
        volumeSelectField.text = ""
        volumePickerView.delegate = self
        volumePickerView.dataSource = self
        
        volumeSelectField.inputView = volumePickerView
        volumeSelectField.placeholder = "Select Volume"
        volumeSelectField.textAlignment = .center
    }
    
    @IBAction func milkPressed(_ sender: Any){
        typeChoose = [0, 1, 0, 0]
        teaButton.backgroundColor = UIColor.blue
        milkButton.backgroundColor = UIColor.green
        coffeeButton.backgroundColor = UIColor.blue
        juiceButton.backgroundColor = UIColor.blue
        volumeSelectField.text = ""
        volumePickerView.delegate = self
        volumePickerView.dataSource = self
        
        volumeSelectField.inputView = volumePickerView
        volumeSelectField.placeholder = "Select Volume"
        volumeSelectField.textAlignment = .center
    }
    
    @IBAction func coffeePressed(_ sender: Any){
        typeChoose = [0, 0, 1, 0]
        teaButton.backgroundColor = UIColor.blue
        milkButton.backgroundColor = UIColor.blue
        coffeeButton.backgroundColor = UIColor.green
        juiceButton.backgroundColor = UIColor.blue
        volumeSelectField.text = ""
        volumePickerView.delegate = self
        volumePickerView.dataSource = self
        
        volumeSelectField.inputView = volumePickerView
        volumeSelectField.placeholder = "Select Volume"
        volumeSelectField.textAlignment = .center
    }
    
    @IBAction func juicePressed(_ sender: Any){
        typeChoose = [0, 0, 0, 1]
        teaButton.backgroundColor = UIColor.blue
        milkButton.backgroundColor = UIColor.blue
        coffeeButton.backgroundColor = UIColor.blue
        juiceButton.backgroundColor = UIColor.green
        volumeSelectField.text = ""
        volumePickerView.delegate = self
        volumePickerView.dataSource = self
        
        volumeSelectField.inputView = volumePickerView
        volumeSelectField.placeholder = "Select Volume"
        volumeSelectField.textAlignment = .center
    }
    
    @IBAction func doneButtonPressed(_ sender: Any){
        if(typeChoose != [0,0,0,0] && volumeSelectField.text != "" && dateField.text != ""){
            let index = typeChoose.firstIndex(of: 1)
            let drinkType = drink_dict[drinks[index!]]
            let volume = volume_dict[String(volumeSelectField.text!)]!
            let calories:Double = calories_dict[drinkType!]! * volume
            print(dateField.text!)
            print(drinkType!, volume)
            print("共攝取" + String(ceil(calories)) + "大卡")
            
            let drinkDatetimeStamp = helper.string2TimeStamp(dateField.text!)
            
            self.networkController.postDrinkData(drinkType: drinkType!, volume: volume, calories: calories, time: String(drinkDatetimeStamp), session_id: self.user.session_id!) {
                (status_code) in
                if (status_code != nil) {
                    print(status_code!)
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        else if(typeChoose == [0,0,0,0]){
            let controller = UIAlertController(title: "尚未選擇飲品類別", message: "請選擇飲品類別", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        else if(dateField.text == ""){
            let controller = UIAlertController(title: "飲用日期為空值", message: "請輸入飲用日期", preferredStyle: .alert)
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
    
    @objc func datePickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在 UILabel 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        // 更新 UILabel 的內容
        dateField.text = formatter.string(from: datePicker.date)
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
