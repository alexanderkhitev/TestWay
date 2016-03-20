//
//  StationViewController.swift
//  TestWay
//
//  Created by Alexsander  on 3/20/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class StationInfoViewController: UIViewController, NSFetchedResultsControllerDelegate {

    // MARK: - var and let
    private var departureFetchedResultController: NSFetchedResultsController!
    var station: DepartureStation!
    
    // MARK: - IBOutlet
    @IBOutlet weak var stationTitleLabel: UILabel!
    @IBOutlet weak var districtTitleLabel: UILabel!
    @IBOutlet weak var regionTitleLabel: UILabel!
    @IBOutlet weak var cityTitleLabel: UILabel!
    @IBOutlet weak var countryTitleLabel: UILabel!
    
    // MARK: - Lificycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - functions
    private func setLabels() {
        guard let stationTitle = station.stationTitle else { return }
        stationTitleLabel.text = "Станция: \(stationTitle)"
        stationTitleLabel.adjustsFontSizeToFitWidth = true
        guard let districtTitle = station.districtTitle else { return }
        districtTitleLabel.text = "Район: \(districtTitle)"
        districtTitleLabel.adjustsFontSizeToFitWidth = true
        guard let regionTitle = station.regionTitle else { return }
        regionTitleLabel.text = "Регион: \(regionTitle)"
        regionTitleLabel.adjustsFontSizeToFitWidth = true
        guard let cityTitle = station.cityTitle else { return }
        cityTitleLabel.text = "Город: \(cityTitle)"
        cityTitleLabel.adjustsFontSizeToFitWidth = true
        guard let countryTitle = station.countryTitle else { return }
        countryTitleLabel.text = "Страна: \(countryTitle)"
        countryTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - IBAction
    @IBAction func selectStation(sender: UIButton) {
        removeFirstStation()
//        @NSManaged var cityId: NSNumber?   ///
//        @NSManaged var cityTitle: String?  ///
//        @NSManaged var countryTitle: String?  ///
//        @NSManaged var districtTitle: String? ///
//        @NSManaged var regionTitle: String?  ///
//        @NSManaged var stationId: NSNumber?  ///
//        @NSManaged var stationTitle: String? ///
//        @NSManaged var point: SelectedDepartureStationPoint?
        CoreDataUtilits.selectedDepartureStation.cityId = station.cityId
        CoreDataUtilits.selectedDepartureStation.cityTitle = station.cityTitle
        CoreDataUtilits.selectedDepartureStation.countryTitle = station.countryTitle
        CoreDataUtilits.selectedDepartureStation.districtTitle = station.districtTitle
        CoreDataUtilits.selectedDepartureStation.regionTitle = station.regionTitle
        CoreDataUtilits.selectedDepartureStation.stationId = station.stationId
        CoreDataUtilits.selectedDepartureStation.stationTitle = station.stationTitle
    
        CoreDataUtilits.selectedDepartureStationPoint.latitude = station.point?.latitude
        CoreDataUtilits.selectedDepartureStationPoint.longitude = station.point?.longitude
        
        CoreDataUtilits.selectedDepartureStation.point = CoreDataUtilits.selectedDepartureStationPoint
        
        print(CoreDataUtilits.selectedDepartureStation.point?.latitude, CoreDataUtilits.selectedDepartureStation.point?.longitude)
        do {
            try CoreDataUtilits.managedObjectContext.save()
            print("saved core data")
            navigationController?.popToRootViewControllerAnimated(true)
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
            let alertController = UIAlertController(title: nil, message: "Произошла ошибка, сохранение не возможно", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ок", style: .Cancel, handler: { (alert) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }

    private func removeFirstStation() {
        departureFetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: CoreDataUtilits.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        departureFetchedResultController.delegate = self
        do {
            try departureFetchedResultController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        guard let selectedStation = departureFetchedResultController.fetchedObjects?.first as? SelectedDepartureStation else { return }
        print(selectedStation.stationTitle, selectedStation.cityTitle, selectedStation.point?.longitude)
        CoreDataUtilits.managedObjectContext.deleteObject(selectedStation as NSManagedObject)
        do {
            try CoreDataUtilits.managedObjectContext.save()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        print(departureFetchedResultController.fetchedObjects?.count)
    }
    
    private func fetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedDepartureStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

}
