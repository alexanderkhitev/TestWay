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
    private var hostFetchedResultController: NSFetchedResultsController!
    var departureStation: DepartureStation!
    var hostStation: HostStation!
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var managedObjectContext: NSManagedObjectContext {
        return appDelegate.managedObjectContext
    }
    
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
        if departureStation != nil {
            guard let stationTitle = departureStation.stationTitle else { return }
            stationTitleLabel.text = "Станция: \(stationTitle)"
            stationTitleLabel.adjustsFontSizeToFitWidth = true
            guard let districtTitle = departureStation.districtTitle else { return }
            districtTitleLabel.text = "Район: \(districtTitle)"
            districtTitleLabel.adjustsFontSizeToFitWidth = true
            guard let regionTitle = departureStation.regionTitle else { return }
            regionTitleLabel.text = "Регион: \(regionTitle)"
            regionTitleLabel.adjustsFontSizeToFitWidth = true
            guard let cityTitle = departureStation.cityTitle else { return }
            cityTitleLabel.text = "Город: \(cityTitle)"
            cityTitleLabel.adjustsFontSizeToFitWidth = true
            guard let countryTitle = departureStation.countryTitle else { return }
            countryTitleLabel.text = "Страна: \(countryTitle)"
            countryTitleLabel.adjustsFontSizeToFitWidth = true
        } else {
            guard let stationTitle = hostStation.stationTitle else { return }
            stationTitleLabel.text = "Станция: \(stationTitle)"
            stationTitleLabel.adjustsFontSizeToFitWidth = true
            guard let districtTitle = hostStation.districtTitle else { return }
            districtTitleLabel.text = "Район: \(districtTitle)"
            districtTitleLabel.adjustsFontSizeToFitWidth = true
            guard let regionTitle = hostStation.regionTitle else { return }
            regionTitleLabel.text = "Регион: \(regionTitle)"
            regionTitleLabel.adjustsFontSizeToFitWidth = true
            guard let cityTitle = hostStation.cityTitle else { return }
            cityTitleLabel.text = "Город: \(cityTitle)"
            cityTitleLabel.adjustsFontSizeToFitWidth = true
            guard let countryTitle = hostStation.countryTitle else { return }
            countryTitleLabel.text = "Страна: \(countryTitle)"
            countryTitleLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    // MARK: - IBAction
    @IBAction func selectStation(sender: UIButton) {
        if departureStation != nil {
            saveDepartureStation()
        } else {
            saveHostStation()
        }
    }

    private func saveDepartureStation() {
        removeDepartureStation()
        let selectedDepartureStation = NSEntityDescription.insertNewObjectForEntityForName("SelectedDepartureStation", inManagedObjectContext: managedObjectContext) as! SelectedDepartureStation
        let selectedDepartureStationPoint = NSEntityDescription.insertNewObjectForEntityForName("SelectedDepartureStationPoint", inManagedObjectContext: managedObjectContext) as! SelectedDepartureStationPoint
        selectedDepartureStation.cityId = departureStation.cityId
        selectedDepartureStation.cityTitle = departureStation.cityTitle
        selectedDepartureStation.countryTitle = departureStation.countryTitle
        selectedDepartureStation.districtTitle = departureStation.districtTitle
        selectedDepartureStation.regionTitle = departureStation.regionTitle
        selectedDepartureStation.stationId = departureStation.stationId
        selectedDepartureStation.stationTitle = departureStation.stationTitle
        
        selectedDepartureStationPoint.latitude = departureStation.point?.latitude
        selectedDepartureStationPoint.longitude = departureStation.point?.longitude
        
        selectedDepartureStation.point = selectedDepartureStationPoint
        
        do {
            try managedObjectContext.save()
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

    private func removeDepartureStation() {
        departureFetchedResultController = NSFetchedResultsController(fetchRequest: fetchDepartureRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        departureFetchedResultController.delegate = self
        do {
            try departureFetchedResultController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        guard let selectedStation = departureFetchedResultController.fetchedObjects?.first as? SelectedDepartureStation else { return }
        print(departureFetchedResultController.fetchedObjects?.count)
        managedObjectContext.deleteObject(selectedStation as NSManagedObject)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
    }
    
    private func fetchDepartureRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedDepartureStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    // host
    private func saveHostStation() {
        removeHostStation()
        let selectedHostStation = NSEntityDescription.insertNewObjectForEntityForName("SelectedHostStation", inManagedObjectContext: managedObjectContext) as! SelectedHostStation
        let selectedHostStationPoint = NSEntityDescription.insertNewObjectForEntityForName("SelectedHostStationPoint", inManagedObjectContext: managedObjectContext) as! SelectedHostStationPoint
        selectedHostStation.cityId = hostStation.cityId
        selectedHostStation.cityTitle = hostStation.cityTitle
        selectedHostStation.countryTitle = hostStation.countryTitle
        selectedHostStation.districtTitle = hostStation.districtTitle
        selectedHostStation.regionTitle = hostStation.regionTitle
        selectedHostStation.stationId = hostStation.stationId
        selectedHostStation.stationTitle = hostStation.stationTitle
        
        selectedHostStationPoint.latitude = hostStation.point?.latitude
        selectedHostStationPoint.longitude = hostStation.point?.longitude
        
        selectedHostStation.point = selectedHostStationPoint
        
        do {
            try managedObjectContext.save()
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
    
    private func removeHostStation() {
        hostFetchedResultController = NSFetchedResultsController(fetchRequest: fetchHostRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        hostFetchedResultController.delegate = self

        do {
            try hostFetchedResultController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        guard let selectedStation = hostFetchedResultController.fetchedObjects?.first as? SelectedHostStation else { return }
        managedObjectContext.deleteObject(selectedStation as NSManagedObject)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
    }
    
    private func fetchHostRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedHostStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

}
