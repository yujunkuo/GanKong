//
//  WaterPopoverViewController.swift
//  GanKong
//
//  Created by 施君諺 on 2020/4/16.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit

class WaterPopoverViewController: UIViewController {
    
    var user = User( )
    let helper = HelperController( )
    let networkController = NetworkController( )
    
    @IBOutlet var waterLabel: UILabel!
    let datePickerView = UIDatePicker()
    @IBOutlet var dateField: UITextField!
    var glass = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.session_id = String((UserDefaults.standard.value(forKey: "session_id") as? String)!)
        updateWater()
        
        datePickerView.datePickerMode = .date
        datePickerView.date = Date()
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        datePickerView.locale = Locale(identifier: "zh_TW")
        
        datePickerView.addTarget(self, action: #selector(WaterPopoverViewController.datePickerChanged), for: .valueChanged)
        
        dateField.inputView = datePickerView
        dateField.placeholder = "Select Date"
        dateField.textAlignment = .center
        
        self.view.addSubview(dateField)
        
    }
    
    private func updateWater(){
        plusButtonPressed(self)
        minusButtonPressed(self)
    }
    
    private func updateLabels() {
        let numOfGlass = String(glass) + " 杯"
        waterLabel.text = numOfGlass
    }
    
    @IBAction func plusButtonPressed(_ sender: Any){
        glass += 1
        updateLabels()
    }
    
    @IBAction func minusButtonPressed(_ sender: Any){
        if (glass != 0){
            glass -= 1
            updateLabels()
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any){
        if(glass != 0 && dateField.text != ""){
            print(dateField.text!)
            let volume = glass * 300
            print("喝水" + String(volume) + "c.c.")
            
            let drinkDatetimeStamp = helper.string2TimeStamp(dateField.text!)
            
            self.networkController.postWaterData(volume: volume, time: String(drinkDatetimeStamp), session_id: self.user.session_id!) {
                            (status_code) in
                                if (status_code != nil) {
                                    print(status_code!)
                                }
                        }
            
            self.dismiss(animated: true, completion: nil)
        }
        else if (dateField.text == ""){
            let controller = UIAlertController(title: "飲用日期為空值", message: "請輸入飲用日期", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        else{
            let controller = UIAlertController(title: "飲水量為零", message: "請輸入飲水量", preferredStyle: .alert)
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
