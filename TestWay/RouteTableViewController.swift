//
//  RouteTableViewController.swift
//  TestWay
//
//  Created by Alexsander  on 3/18/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class RouteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - var and let
    var dataManager: DataManager!
    private var selectedDepartureFetchedController: NSFetchedResultsController!
    private var selectedHostFetchedController: NSFetchedResultsController!
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var managedObjectContext: NSManagedObjectContext {
        return appDelegate.managedObjectContext
    }
//    private var selectedDepartureStation: SelectedDepartureStation!
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var departureStationOutlet: UITableViewCell!
    @IBOutlet weak var hostStationOutlet: UITableViewCell!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        dataManager = DataManager()
        dataManager.saveData(view)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setSetting()
        setFetchedResultsControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    private func tableViewOpensController(index: NSIndexPath) {
        switch index {
        case NSIndexPath(forRow: 0, inSection: 0):
            performSegueWithIdentifier("showDepartureTVC", sender: self)
        case NSIndexPath(forRow: 0, inSection: 1):
            performSegueWithIdentifier("showHostTVC", sender: self)
        case NSIndexPath(forRow: 0, inSection: 2):
            break
        default: break
        }
    }
    
    // MARK: - functions
    private func setSetting() {
        navigationController?.navigationBarHidden = true
        tabBarController?.tabBar.hidden = false
    }
    
    // MARK: - getting data of selected stations
    private func setFetchedResultsControllers() {
        selectedDepartureFetchedController = NSFetchedResultsController(fetchRequest: departureFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        selectedDepartureFetchedController.delegate = self
        do {
            try selectedDepartureFetchedController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.localizedDescription)
        }
        guard let departureStation = selectedDepartureFetchedController.fetchedObjects?.first as? SelectedDepartureStation else {
            departureStationOutlet.textLabel?.text = "Откуда?"
            return
        }
        guard let departureStationTitle = departureStation.stationTitle else {
            departureStationOutlet.textLabel?.text = "Откуда?"
            return
        }
        departureStationOutlet.textLabel?.text = departureStationTitle
        
        // host
        selectedHostFetchedController = NSFetchedResultsController(fetchRequest: hostFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        selectedHostFetchedController.delegate = self
        do {
            try selectedHostFetchedController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        
        guard let hostStation = selectedHostFetchedController.fetchedObjects?.first as? SelectedHostStation else {
            hostStationOutlet.textLabel?.text = "Куда?"
            return
        }
        
        guard let hostStationTitle = hostStation.stationTitle else { return }
        hostStationOutlet.textLabel?.text = hostStationTitle
    }
    
    private func departureFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedDepartureStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    private func hostFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedHostStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}

// MARK: - Table delegate

extension RouteTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableViewOpensController(indexPath)
    }
}
