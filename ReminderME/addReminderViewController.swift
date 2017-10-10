//
//  addReminderViewController.swift
//  ReminderME
//
//  Created by Nusri Samath on 10/7/17.
//  Copyright © 2017 Nusri Samath. All rights reserved.
//

import UIKit
import UserNotifications

class addReminderViewController: UIViewController,UITextFieldDelegate,UNUserNotificationCenterDelegate {
    
    var reminder: Reminder?

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var reminderTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.reminderTextField.delegate = self
    
        timePicker.minimumDate = Date()
        timePicker.locale = NSLocale.current
        
        UNUserNotificationCenter.current().requestAuthorization(options:[[.alert, .sound]], completionHandler: {
            (granted, error) in
            // Handle Error
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: check the remindertextfeild datepicker
    func checkName(){
        let text = reminderTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func checkDate(){
        if NSDate().earlierDate(timePicker.date) == timePicker.date{
            saveButton.isEnabled = false
        }
    }
    
    //MARK: return keybord
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: End of the Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    @IBAction func timeChange(_ sender: UIDatePicker) {
        checkDate()
    }
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil )
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        //have to implemet the notification part
        if let barButton = sender as? UIBarButtonItem {
            if saveButton == barButton {
                
                let name = reminderTextField.text
                let time = timePicker.date
                
                let calendar = Calendar(identifier: .gregorian)
                let components = calendar.dateComponents(in: .current, from: time)
                let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
                
                print("the time \(time)")
                
                let content = UNMutableNotificationContent()
                
                content.title = "Reminder"
                content.body = "Don't forget to do \(String(describing: name!))"
                //content.badge = 0
                content.sound = UNNotificationSound.default()

                reminder = Reminder(name: name!, time: time as NSDate, notification: content)
        
                let requestIdentifier = "demoNotification"
                let request = UNNotificationRequest(identifier: requestIdentifier,
                                                    content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request,withCompletionHandler: { (error) in
                // Handle error
                })
                
                
                }
            }
        }
    
}
