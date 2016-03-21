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

class DateSelectorViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - var and let
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var managedObjectContext: NSManagedObjectContext! {
        return appDelegate.managedObjectContext
    }
    private var fetchedResultController: NSFetchedResultsController!
    
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
        removePreviousDate()
        let selectedDateEntity = NSEntityDescription.insertNewObjectForEntityForName("SelectedDate", inManagedObjectContext: managedObjectContext) as! SelectedDate
        selectedDateEntity.date = datePicker.date
        do {
            try managedObjectContext.save()
            navigationController?.popToRootViewControllerAnimated(true)
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
            let alertController = UIAlertController(title: nil, message: "Произошла ошибка во время сохранения", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - functions
    
    private func setUISetting() {
        navigationController?.navigationBarHidden = false
        tabBarController?.tabBar.hidden = true
    }
    
    private func removePreviousDate() {
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        guard let previousDate = fetchedResultController.fetchedObjects?.first as? SelectedDate else { return }
        managedObjectContext.deleteObject(previousDate)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
    }
    
    private func fetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedDate")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}
