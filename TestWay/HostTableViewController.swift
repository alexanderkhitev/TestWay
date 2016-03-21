//
//  SelectHostTableViewController.swift
//  TestWay
//
//  Created by Alexsander  on 3/19/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class HostTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - var and let
    private var fetchedResultController: NSFetchedResultsController!
    // сделанно два NSFetchedResultsController, так как они выполняют разную функцию, можно было бы реализовать используя лишь один NSFetchedResultsController, но это задел на будушие, так как например можно в функции setFetchedResultController извлечь еще какие либо данные с помощью fetchedResultController, но станции должны быть обязательно для поиска в UISearchController
    private var stationFetchedResultController: NSFetchedResultsController!
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var managedObjectContext: NSManagedObjectContext! {
        return appDelegate.managedObjectContext
    }
    private var cities = [HostCity]()
    private var searchController = UISearchController()
    private var searchResults: [HostStation]? = nil
    private var searchPredicate: NSPredicate!
    
    // MARK: - Lifycycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        setSearchController()
        setFetchedResultController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.definesPresentationContext = true
        setSetting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        searchResults?.removeAll()
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
            return searchResults?.count ?? 0
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
        let cell = tableView.dequeueReusableCellWithIdentifier("hostCell", forIndexPath: indexPath) as! HostTableViewCell
        if !searchController.active {
            let stations = Array(cities[indexPath.section].stations!) as! [HostStation]
            let station = stations[indexPath.row]
            // Configure the cell...
            cell.stationTitleLabel.text = station.stationTitle
            cell.countryTitleLabel.text = station.countryTitle
            cell.cityTitleLabel.text = station.cityTitle
        } else {
            let station = searchResults![indexPath.row]
            cell.stationTitleLabel.text = station.stationTitle
            cell.countryTitleLabel.text = station.countryTitle
            cell.cityTitleLabel.text = station.cityTitle
        }
        return cell
    }
    
    // MARK: - functions
    private func setSetting() {
        navigationController?.navigationBarHidden = false
        tabBarController?.tabBar.hidden = true
    }
    
    private func setFetchedResultController() {
        fetchedResultController = NSFetchedResultsController(fetchRequest: cityFetchResult(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        cities = fetchedResultController.fetchedObjects as! [HostCity]
        var numberOfcityStations = 0
        for city in cities {
            numberOfcityStations += (city.stations?.count)!
        }
        print("numberOfcityStations", numberOfcityStations)
        //
        stationFetchedResultController = NSFetchedResultsController(fetchRequest: stationFetchResult(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        stationFetchedResultController.delegate = self
        do {
            try stationFetchedResultController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
    }
    
    private func cityFetchResult() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "HostCity")
        let sortDescriptor = NSSortDescriptor(key: "cityTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    private func stationFetchResult() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "HostStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}

// MARK: - delegate functions

extension HostTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let infoController = UIUtilits.mainStoryboard.instantiateViewControllerWithIdentifier("StationInfoViewController") as! StationInfoViewController
        if !searchController.active {
            guard let stations = Array(cities[indexPath.section].stations!) as? [HostStation] else { return }
            let currentStation = stations[indexPath.row]
            print(currentStation.stationTitle, currentStation.cityTitle, currentStation.countryTitle)
            infoController.hostStation = currentStation
        } else {
            guard let currentStation = searchResults?[indexPath.row] else { return }
            print(currentStation.stationTitle, currentStation.cityTitle, currentStation.countryTitle)
            infoController.hostStation = currentStation
        }
        showViewController(infoController, sender: self)
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
}

// MARK: - searchController and searchBar and their functions

extension HostTableViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating  {
    
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
        searchResults?.removeAll()
        guard let searchText = searchController.searchBar.text else { return }
        searchPredicate = NSPredicate(format: "stationTitle contains [cd] %@ OR cityTitle contains [cd] %@", searchText, searchText)
        searchResults = stationFetchedResultController.fetchedObjects?.filter() {
            return searchPredicate.evaluateWithObject($0)
            } as? [HostStation]
        tableView.reloadData()
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        tableView.reloadData()
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        searchPredicate = nil
        searchResults?.removeAll()
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResultsForSearchController(searchController)
    }
}
