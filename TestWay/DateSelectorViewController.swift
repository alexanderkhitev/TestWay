//
//  DateSelectorViewController.swift
//  TestWay
//
//  Created by Alexsander  on 3/21/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DateSelectorViewController: UIViewController {
    
    // MARK: - var and let
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var managedObjectContext: NSManagedObjectContext! {
        return appDelegate.managedObjectContext
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.datePickerMode = .DateAndTime
        }
    }
    
    // MARK: - Lificycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setUISetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    @IBAction func selectCurrentDate(sender: UIButton) {
        let selectedDateEntity = NSEntityDescription.insertNewObjectForEntityForName("SelectedDate", inManagedObjectContext: managedObjectContext) as! SelectedDate
        selectedDateEntity.date = datePicker.date
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
    }
    // MARK: - functions
    
    private func setUISetting() {
        navigationController?.navigationBarHidden = false
        tabBarController?.tabBar.hidden = true
    }
    
    private func removePreviousDate() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
