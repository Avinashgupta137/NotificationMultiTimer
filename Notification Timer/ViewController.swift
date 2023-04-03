//
//  ViewController.swift
//  Notification Timer
//
//  Created by IPS-108 on 30/03/23.
//
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, passTime {
    
    
    
    var timers = [[String: Any]]()
    var timer: Timer?
    var counter = Int()
    var timeInterval = Int()
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "TbCell", bundle: nil), forCellReuseIdentifier: "cell1")
    }
    
    func passTheTime(totalSecs: Int) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        var timerInfo = [String: Any]()
        timerInfo["totalSecs"] = totalSecs
        timeInterval = totalSecs
        timerInfo["counter"] = totalSecs
        timerInfo["timer"] = timer
        timerInfo["timeString"] = ""
        timerInfo["delegate"] = self
        timers.append(timerInfo)
        tblView.reloadData()
        showNotification()
    }
    
    @objc func updateTimer(timer: Timer) {
        guard let index = timers.firstIndex(where: { $0["timer"] as? Timer === timer }) else {
            return
        }
        var timerInfo = timers[index]
        if var counter = timerInfo["counter"] as? Int, counter > 0 {
            counter -= 1
            let hours = counter / 3600
            let minutes = (counter % 3600) / 60
            let seconds = counter % 60
            timerInfo["timeString"] = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            timerInfo["counter"] = counter
            timers[index] = timerInfo
            tblView.reloadData()
        } else {
            timer.invalidate()
            timerInfo["timer"] = nil
            timers[index] = timerInfo
            print("Timer finished")
        }
    }
    func showNotification(){
        let noticenter = UNUserNotificationCenter.current()
        noticenter.requestAuthorization(options: [.alert,.sound]) { allowed, error in
            if allowed{
                print("Permission Granted")
            }
            else{
                print("Permission denied")
            }
        }
     
        //let imageUrl = Bundle.main.url(forResource: "doge", withExtension: "png")!

        //let attachment = try! UNNotificationAttachment(identifier: "doge", url: imageUrl, options: nil)
        
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.subtitle = "Notification Subtitle"
        //content.attachments = [attachment]
        content.body = "Notification Body"
        //content.setValue(attrStr, forKey: "body")
        content.sound = .default
        
        
        //let identifier = "oop"
        
        
        //let calender = Calendar.current
        //var dateComponents = DateComponents(calendar: calender, timeZone: TimeZone.current)
//        dateComponents.hour = hour
//        dateComponents.minute = minute
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(timeInterval)", content: content, trigger: trigger)
        noticenter.add(request){ (error) in
            if error != nil {
                print("Failed")
            } else {
                print("Success")
            }
        }
    }

    
    @IBAction func nxtPage(_ sender: UIButton) {
        let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "datePickerView") as! datePickerView
        self.navigationController?.pushViewController(nextViewController, animated: true)
        nextViewController.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TbCell
        let timerInfo = timers[indexPath.row]
        if let timeString = timerInfo["timeString"] as? String {
            cell.lblNoti.text = timeString
            if timerInfo["timeString"] as! String == "00:00:00"{
                cell.lblNoti.text = ""
            }
            else{
                cell.lblNoti.text = timeString
            }
        }
        return cell
    }
}
