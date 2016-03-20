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
        let selectedDepartureStation = NSEntityDescription.insertNewObjectForEntityForName("SelectedDepartureStation", inManagedObjectContext: managedObjectContext) as! SelectedDepartureStation
        let selectedDepartureStationPoint = NSEntityDescription.insertNewObjectForEntityForName("SelectedDepartureStationPoint", inManagedObjectContext: managedObjectContext) as! SelectedDepartureStationPoint
        selectedDepartureStation.cityId = station.cityId
        selectedDepartureStation.cityTitle = station.cityTitle
        selectedDepartureStation.countryTitle = station.countryTitle
        selectedDepartureStation.districtTitle = station.districtTitle
        selectedDepartureStation.regionTitle = station.regionTitle
        selectedDepartureStation.stationId = station.stationId
        selectedDepartureStation.stationTitle = station.stationTitle
    
        selectedDepartureStationPoint.latitude = station.point?.latitude
        selectedDepartureStationPoint.longitude = station.point?.longitude
        
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

    private func removeFirstStation() {
        departureFetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
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
    
    private func fetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SelectedDepartureStation")
        let sortDescriptor = NSSortDescriptor(key: "stationTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

}
