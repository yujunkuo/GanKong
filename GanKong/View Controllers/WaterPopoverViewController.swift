//
//  WaterPopoverViewController.swift
//  GanKong
//
//  Created by 施君諺 on 2020/4/16.
//  Copyright © 2020 KuoKuo. All rights reserved.
//

import UIKit

class WaterPopoverViewController: UIViewController {
    
    @IBOutlet var waterLabel: UILabel!
    var volumne = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWater()

    }
    
    private func updateWater(){
        plusButtonPressed(self)
        minusButtonPressed(self)
    }
    
    private func updateLabels() {
        var numOfGlass = String(volumne) + " 杯"
        waterLabel.text = numOfGlass
    }
    
    @IBAction func plusButtonPressed(_ sender: Any){
        volumne += 1
        updateLabels()
    }
    
    @IBAction func minusButtonPressed(_ sender: Any){
        if (volumne != 0){
            volumne -= 1
            updateLabels()
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any){
        if(volumne != 0){
            let total = volumne * 300
            print("喝水" + String(total) + "c.c.")
            self.dismiss(animated: true, completion: nil)
        }
        else{
            let controller = UIAlertController(title: "飲水量為零", message: "請輸入飲水量", preferredStyle: .alert)
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
