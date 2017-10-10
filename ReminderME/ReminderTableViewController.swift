//
//  ReminderTableViewController.swift
//  ReminderME
//
//  Created by Nusri Samath on 10/7/17.
//  Copyright © 2017 Nusri Samath. All rights reserved.
//

import UIKit

class ReminderTableViewController: UITableViewController {
    //MARK: Properties
    var reminders = [Reminder]()
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        //load the Reminders
        if let saveReminders = loadReminder(){
            reminders += saveReminders
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)

        // Configure the cell...
        let reminder = reminders[indexPath.row]
        cell.textLabel?.text = reminder.name
        cell.detailTextLabel?.text = "Due " + dateFormatter.string(from: reminder.time as Date)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let toRemove = reminders.remove(at:indexPath.row)
            //toRemove.delete(self)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveReminders()
        }    
    }
    
    @IBAction func unwindToReminderList(sender: UIStoryboardSegue){
        if let sourceView =  sender.source as? addReminderViewController, let reminder = sourceView.reminder{
            //add a new reminder
            let newIndexPath = IndexPath(row: reminders.count, section: 0)
            reminders.append(reminder)
            tableView.insertRows(at: [newIndexPath as IndexPath],with: .bottom)
            saveReminders()
            tableView.reloadData()
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: saveReminders
    func saveReminders() {
        //let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(reminders, toFile: Reminder.ArchiveURL.path!)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(reminders, toFile: Reminder.archiveURL.path)
        if(isSuccessfulSave){
            print("reminder save successfully!")
        }else{
            print("fail to save reminder!")
        }
    }
    
    func loadReminder()->[Reminder]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Reminder.archiveURL.path) as? [Reminder ]
    }
}
