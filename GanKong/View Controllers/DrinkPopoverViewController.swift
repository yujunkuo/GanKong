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
    
    var typeChoose:String = ""
    let drinks = ["單茶", "奶類", "咖啡", "拿鐵", "果汁", "豆漿", "米漿", "汽水", "可可", "運動"]
    let drink_volume = ["小杯(500 c.c)", "大杯(700 c.c.)"]
    let coffee_volume = ["咖啡小杯(240 c.c.)", "咖啡中杯(360 c.c.)", "咖啡大杯(480 c.c.)"]
    let volume_dict:Dictionary = ["咖啡小杯(240 c.c.)":240.0, "咖啡中杯(360 c.c.)":360.0, "咖啡大杯(480 c.c.)":480.0, "小杯(500 c.c)":500.0, "大杯(700 c.c.)":700.0]
    // 茶每 700 毫升 100 大卡，奶類 700 毫升 390 大卡，果汁 100 毫升 50 大卡
    // 咖啡 100 毫升 4.2 大卡
    let calories_dict:Dictionary = ["單茶":0.142857, "奶類":0.557142, "咖啡":0.042, "拿鐵":0.6, "果汁":0.5,
                                    "豆漿":0.54, "米漿":0.466, "汽水":0.409, "可可":0.774, "運動":0.11]
    var toppings:Bool = false
    
    func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBOutlet var Button1: UIButton!
    @IBOutlet var Button2: UIButton!
    @IBOutlet var Button3: UIButton!
    @IBOutlet var Button4: UIButton!
    @IBOutlet var Button5: UIButton!
    @IBOutlet var Button6: UIButton!
    @IBOutlet var Button7: UIButton!
    @IBOutlet var Button8: UIButton!
    @IBOutlet var Button9: UIButton!
    @IBOutlet var Button10: UIButton!
    @IBOutlet var noToppingsButton: UIButton!
    @IBOutlet var yesToppingsButton: UIButton!

    @IBOutlet var datePicker: UIDatePicker!
    
    let volumePickerView = UIPickerView()
    @IBOutlet var volumeSelectField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.session_id = String((UserDefaults.standard.value(forKey: "session_id") as? String)!)
        
        setButtonOutlook()
        
        volumePickerView.delegate = self
        volumePickerView.dataSource = self
        
        volumeSelectField.inputView = volumePickerView
        volumeSelectField.placeholder = "Please choose drink type first"
        volumeSelectField.textAlignment = .center
        
        noToppingsButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        
        self.view.addSubview(volumeSelectField)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (typeChoose == "咖啡" || typeChoose == "拿鐵"){
            return coffee_volume.count
        }
        else if typeChoose == ""{
            return 0
        }
        else{
            return drink_volume.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (typeChoose == "咖啡" || typeChoose == "拿鐵"){
            return coffee_volume[row]
        }
        else if typeChoose == ""{
            return nil
        }
        else{
            return drink_volume[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (typeChoose == "咖啡" || typeChoose == "拿鐵"){
            volumeSelectField.text = coffee_volume[row]
            volumeSelectField.resignFirstResponder()
        }
        else if typeChoose == ""{
        }
        else{
            volumeSelectField.text = drink_volume[row]
            volumeSelectField.resignFirstResponder()
        }
        
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "yyyy-MM-dd"
    }
    
    @objc func setButtonColor(){
        Button1.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        Button2.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        Button3.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        Button4.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        Button5.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        Button6.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        Button7.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        Button8.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        Button9.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        Button10.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
    }
    
    @objc func setButtonOutlook(){
        Button1.setTitle(drinks[0], for: .normal)
        Button2.setTitle(drinks[1], for: .normal)
        Button3.setTitle(drinks[2], for: .normal)
        Button4.setTitle(drinks[3], for: .normal)
        Button5.setTitle(drinks[4], for: .normal)
        Button6.setTitle(drinks[5], for: .normal)
        Button7.setTitle(drinks[6], for: .normal)
        Button8.setTitle(drinks[7], for: .normal)
        Button9.setTitle(drinks[8], for: .normal)
        Button10.setTitle(drinks[9], for: .normal)
        
        setButtonColor()
    }
    
    @objc func setToppingsButtonColor(){
        noToppingsButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        yesToppingsButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func drinkTypeButtonPressed(_ sender: UIButton){
        setButtonColor()
        
        switch sender.tag{
        case 1:
            typeChoose = Button1.currentTitle!
            Button1.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        case 2:
            typeChoose = Button2.currentTitle!
            Button2.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        case 3:
            typeChoose = Button3.currentTitle!
            Button3.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        case 4:
            typeChoose = Button4.currentTitle!
            Button4.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        case 5:
            typeChoose = Button5.currentTitle!
            Button5.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        case 6:
            typeChoose = Button6.currentTitle!
            Button6.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        case 7:
            typeChoose = Button7.currentTitle!
            Button7.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        case 8:
            typeChoose = Button8.currentTitle!
            Button8.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        case 9:
            typeChoose = Button9.currentTitle!
            Button9.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        case 10:
            typeChoose = Button10.currentTitle!
            Button10.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        default:
            setButtonColor()
        }
        volumeSelectField.text = ""
        volumePickerView.delegate = self
        volumePickerView.dataSource = self
               
        volumeSelectField.inputView = volumePickerView
        volumeSelectField.placeholder = "Select Volume"
        volumeSelectField.textAlignment = .center
    }
    
    @IBAction func toppingsButtonPressed(_ sender: UIButton){
        setToppingsButtonColor()

        switch sender.tag{
        case 1:
            typeChoose = Button1.currentTitle!
            noToppingsButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
            toppings = false
        case 2:
            typeChoose = Button2.currentTitle!
            yesToppingsButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
            toppings = true
        default:
            noToppingsButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0.5)
        }
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any){
        if(typeChoose != "" && volumeSelectField.text != ""){
            let volume = volume_dict[String(volumeSelectField.text!)]!
            var calories:Double = calories_dict[typeChoose]! * volume
            let dateValue = DateFormatter()
            dateValue.dateFormat = "yyyy-MM-dd"
            let date = dateValue.string(from: datePicker.date)
            print(date)
            print(typeChoose, volume)
            if toppings == false{
                print("沒加料")
            }else{
                calories += 110
                print("有加料")
            }
            print("共攝取" + String(ceil(calories)) + "大卡")
            let drinkDatetimeStamp = helper.string2TimeStamp(date)
            
            self.networkController.postDrinkData(drinkType: typeChoose, volume: volume, calories: calories, time: String(drinkDatetimeStamp), session_id: self.user.session_id!) {
                (status_code) in
                if (status_code != nil) {
                    print(status_code!)
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        else if(typeChoose == ""){
            let controller = UIAlertController(title: "尚未選擇飲品類別", message: "請選擇飲品類別", preferredStyle: .alert)
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

