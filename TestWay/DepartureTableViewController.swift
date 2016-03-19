//
//  SelectRouteTableViewController.swift
//  TestWay
//
//  Created by Alexsander  on 3/19/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DepartureTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - var and let
    private var fetchedResultController: NSFetchedResultsController!
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var managedObjectContext: NSManagedObjectContext! {
        return appDelegate.managedObjectContext
    }
    private var cities = [DepartureCity]()
    private var searchController = UISearchController()
    
    // MARK: - Lifycycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.definesPresentationContext = true
        setSetting()
        setSearchController()
        print("DepartureTableViewController")
        fetchedResultController = NSFetchedResultsController(fetchRequest: cityFetchResult(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        cities = fetchedResultController.fetchedObjects as! [DepartureCity]
        var numberOfcityStations = 0
        for city in cities {
            numberOfcityStations += (city.stations?.count)!
        }
        print("numberOfcityStations", numberOfcityStations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if !searchController.active {
            return cities.count ?? 0
        } else {
            return 1 ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchController.active {
            return cities[section].stations!.count ?? 0
        } else {
            return 1 ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !searchController.active {
            if let cityTitle = cities[section].cityTitle, let countryTitle = cities[section].countryTitle {
                return "\(cityTitle) \(countryTitle)"
            } else {
                return cities[section].cityTitle ?? ""
            }
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("departureCell", forIndexPath: indexPath) as! DepartureTableViewCell
        if !searchController.active {
            let stations = Array(cities[indexPath.section].stations!) as! [DepartureStation]
            let station = stations[indexPath.row]
            // Configure the cell...
            cell.stationTitleLabel.text = station.stationTitle
            cell.countryTitleLabel.text = station.countryTitle
            cell.cityTitleLabel.text = station.cityTitle
        } else {
            cell.stationTitleLabel.text = ""
            cell.countryTitleLabel.text = ""
            cell.cityTitleLabel.text = ""
        }
        //
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - functions
    private func setSetting() {
        navigationController?.navigationBarHidden = false
        tabBarController?.tabBar.hidden = true
    }
    
    private func cityFetchResult() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "DepartureCity")
        let sortDescriptor = NSSortDescriptor(key: "cityTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
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

// MARK: - delegate functions

extension DepartureTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let stations = Array(cities[indexPath.section].stations!) as? [DepartureStation] else { return }
        let station = stations[indexPath.row]
        print(station.stationTitle, station.countryTitle, station.cityTitle)
    }
}

// MARK: - searchController and searchBar and their functions

extension DepartureTableViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating  {
    
    private func setSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        print("willPresentSearchController")
        tableView.reloadData()
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        tableView.reloadData()
    }
}
