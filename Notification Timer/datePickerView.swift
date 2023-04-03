//
//  datePicker.swift
//  Notification Timer
//
//  Created by IPS-108 on 30/03/23.
//

import UIKit

protocol passTime{
    func passTheTime(totalSecs: Int)
}

class datePickerView: UIViewController {
    
    var delegate: passTime?
    var hour = Int()
    var minute = Int()
    var second = Int()
    var totalSeconds = Int()
    let calender = Calendar.current
    let now = Date()
    
    @IBOutlet weak var timeSelector: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func selectedTime(_ sender: UIDatePicker) {
        let selectedHour = calender.component(.hour, from: timeSelector.date)
        let selectedMinute = calender.component(.minute, from: timeSelector.date)
        let selectedSecond = calender.component(.second, from: timeSelector.date)
        
        let selectedTime = Calendar.current.date(bySettingHour: selectedHour, minute: selectedMinute, second: selectedSecond, of: now)!
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: now, to: selectedTime)
        
        hour = components.hour ?? 0
        minute = components.minute ?? 0
        second = components.second ?? 0
        
        totalSeconds = hour*3600 + minute*60 + second
        print("TH = \(hour*3600)")
        print("TM = \(minute*60)")
        print("TS = \(second)")
        print(totalSeconds)
        
    }
    @IBAction func submitData(_ sender: UIButton) {
        
        delegate?.passTheTime(totalSecs: totalSeconds)
        self.navigationController?.popViewController(animated: true)
    }
    

}
