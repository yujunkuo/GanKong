//
//  ExercisePopoverViewController.swift
//  GanKong
//
//  Created by 施君諺 on 2020/4/22.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit

class ExercisePopoverViewController: UIViewController {
    
    var user = User( )
    
    let helper = HelperController()
    let networkController = NetworkController( )
    
    var typeChoose:[Int] = [0, 0, 0, 0, 0, 0, 0, 0]
    
    let exerciseList:Array = ["jogging", "swimming", "cycling", "yoga",
                              "dancing", "fitness", "ball", "above18"]
    
    let mets:Dictionary = ["jogging":8.2, "swimming":6.3, "cycling":6.2, "yoga":3,
                           "dancing":5.3, "fitness":10, "ball":6.3, "above18":1.75]
    
    func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBOutlet var joggingButton: UIButton!
    @IBOutlet var swimmingButton: UIButton!
    @IBOutlet var cyclingButton: UIButton!
    @IBOutlet var yogaButton: UIButton!
    @IBOutlet var dancingButton: UIButton!
    @IBOutlet var fitnessButton: UIButton!
    @IBOutlet var ballButton: UIButton!
    @IBOutlet var above18Button: UIButton!
    
    let startDatePickerView = UIDatePicker()
    @IBOutlet var startDateField: UITextField!
    let endDatePickerView = UIDatePicker()
    @IBOutlet var endDateField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.session_id = String((UserDefaults.standard.value(forKey: "session_id") as? String)!)
        
        joggingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        swimmingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        cyclingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        yogaButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        dancingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        fitnessButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        ballButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        above18Button.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        
        startDatePickerView.datePickerMode = .dateAndTime
        startDatePickerView.date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        startDatePickerView.locale = Locale(identifier: "zh_TW")
        
        startDatePickerView.addTarget(self, action: #selector(ExercisePopoverViewController.startDatePickerChanged), for: .valueChanged)
        
        startDateField.inputView = startDatePickerView
        startDateField.placeholder = "Select Start Date"
        startDateField.textAlignment = .center
        
        endDatePickerView.datePickerMode = .dateAndTime
        endDatePickerView.date = Date()
        
        endDatePickerView.locale = Locale(identifier: "zh_TW")
        
        endDatePickerView.addTarget(self, action: #selector(ExercisePopoverViewController.endDatePickerChanged), for: .valueChanged)
        
        endDateField.inputView = endDatePickerView
        endDateField.placeholder = "Select End Date"
        endDateField.textAlignment = .center

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joggingPressed(_ sender: Any){
        typeChoose = [1, 0, 0, 0, 0, 0, 0, 0]
        joggingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:1)
        swimmingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        cyclingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        yogaButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        dancingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        fitnessButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        ballButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        above18Button.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
    }
    
    @IBAction func swimmingPressed(_ sender: Any){
        typeChoose = [0, 1, 0, 0, 0, 0, 0, 0]
        joggingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        swimmingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:1)
        cyclingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        yogaButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        dancingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        fitnessButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        ballButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        above18Button.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
    }
    
    @IBAction func cyclingPressed(_ sender: Any){
        typeChoose = [0, 0, 1, 0, 0, 0, 0, 0]
        joggingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        swimmingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        cyclingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:1)
        yogaButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        dancingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        fitnessButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        ballButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        above18Button.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
    }
    
    @IBAction func yogaPressed(_ sender: Any){
        typeChoose = [0, 0, 0, 1, 0, 0, 0, 0]
        joggingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        swimmingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        cyclingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        yogaButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:1)
        dancingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        fitnessButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        ballButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        above18Button.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
    }
    
    @IBAction func dancingPressed(_ sender: Any){
        typeChoose = [0, 0, 0, 0, 1, 0, 0, 0]
        joggingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        swimmingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        cyclingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        yogaButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        dancingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:1)
        fitnessButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        ballButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        above18Button.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
    }
    
    @IBAction func fitnessPressed(_ sender: Any){
        typeChoose = [0, 0, 0, 0, 0, 1, 0, 0]
        joggingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        swimmingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        cyclingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        yogaButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        dancingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        fitnessButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:1)
        ballButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        above18Button.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
    }
    
    @IBAction func ballPressed(_ sender: Any){
        typeChoose = [0, 0, 0, 0, 0, 0, 1, 0]
        joggingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        swimmingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        cyclingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        yogaButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        dancingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        fitnessButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        ballButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:1)
        above18Button.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
    }
    
    @IBAction func above18Pressed(_ sender: Any){
        typeChoose = [0, 0, 0, 0, 0, 0, 0, 1]
        joggingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        swimmingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        cyclingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        yogaButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        dancingButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        fitnessButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        ballButton.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:0)
        above18Button.backgroundColor = UIColor.init(red: 227/255, green: 168/255, blue: 105/255, alpha:1)
    }
    
    @objc func startDatePickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在 UILabel 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 更新 UILabel 的內容
        startDateField.text = formatter.string(from: datePicker.date)
    }
    
    @objc func endDatePickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在 UILabel 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 更新 UILabel 的內容
        endDateField.text = formatter.string(from: datePicker.date)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any){
        if(typeChoose != [0,0,0,0,0,0,0,0] && startDateField.text != "" && endDateField.text != ""){
            let index = typeChoose.firstIndex(of: 1)
            let exerciseType = exerciseList[index!]
            let metsOfExercise = mets[exerciseType]
            print(startDateField.text!)
            print(endDateField.text!)
            let startDatetimeStamp = helper.string2TimeStampForTime(startDateField.text!)
            let endDatetimeStamp = helper.string2TimeStampForTime(endDateField.text!)
            let duration = (endDatetimeStamp - startDatetimeStamp) / (60*60) //in hour
            let weight = user.weightInKilograms
            print(weight)
            let calories:Double = metsOfExercise! * duration
            print(exerciseType)
            print("共消耗" + String(ceil(calories)) + "大卡")
            
            self.networkController.postExerciseData(exerciseType: exerciseType, calories: calories, startTime: String(startDatetimeStamp), endTime:String(endDatetimeStamp), session_id: self.user.session_id!) {
                (status_code) in
                if (status_code != nil) {
                    print(status_code!)
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        else if(typeChoose == [0,0,0,0,0,0,0,0]){
            let controller = UIAlertController(title: "尚未選擇運動類別", message: "請選擇運動類別", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        else if(startDateField.text == ""){
            let controller = UIAlertController(title: "運動起始時間為空值", message: "請輸入起始時間", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        else{
            let controller = UIAlertController(title: "運動結束時間為空值", message: "請輸入結束時間", preferredStyle: .alert)
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
