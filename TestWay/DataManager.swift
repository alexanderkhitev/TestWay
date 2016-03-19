//
//  DataManager.swift
//  TestWay
//
//  Created by Alexsander  on 3/18/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import DATAStack
import Sync
import MBProgressHUD
import CoreData

public class DataManager {
    
    // MARK: - var and let
    private let bundle = NSBundle.mainBundle()
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
//    private var dataStack: DATAStack! {
//        return appDelegate.dataStack
//    }
//    
    public func saveData(view: UIView?) {
        if let _view = view {
            let progress = MBProgressHUD.showHUDAddedTo(_view, animated: true)
            progress.mode = .Indeterminate
            progress.removeFromSuperViewOnHide = true
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.save()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    progress.hide(true)
                })
            })
        }
    }
    
    private func save() {
        guard let jsonPath = bundle.pathForResource("allStations", ofType: "json") else { return }
        guard let jsonData = NSData(contentsOfFile: jsonPath) else { return }
        
        let json = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as! [String : AnyObject]
        
        if let departureCity = json["citiesFrom"] as? [[String: AnyObject]] {
            let managedObjectContext = appDelegate.managedObjectContext
//            let departureCityEntity = entity("DepartureCity", managedObjectContext: managedObjectContext) as! DepartureCity
//            let departureCityPointEntity = entity("DeparturePoint", managedObjectContext: managedObjectContext) as! DeparturePoint
            let departureStationEntity = entity("DepartureStation", managedObjectContext: managedObjectContext) as! DepartureStation
            let departureStationPointEntity = entity("DepartureStationPoint", managedObjectContext: managedObjectContext) as! DepartureStationPoint
            var checkDigit = 0
            for city in departureCity {
                let departureCityEntity = entity("DepartureCity", managedObjectContext: managedObjectContext) as! DepartureCity
                let departureCityPointEntity = entity("DeparturePoint", managedObjectContext: managedObjectContext) as! DeparturePoint
                
                guard let countryTitle = city["countryTitle"] as? String else { break }
                guard let point = city["point"] as? [String : AnyObject] else { break }
                guard let longitude = point["longitude"] as? Double else { break } // city point
                guard let latitude = point["latitude"] as? Double else { break } // city point
                guard let districtTitle = city["districtTitle"] as? String else { break }
                guard let cityId = city["cityId"] as? NSNumber else { break }
                guard let cityTitle = city["cityTitle"] as? String else { break }
                guard let regionTitle = city["regionTitle"] as? String else { break }
                guard let stations = city["stations"] as? [[String : AnyObject]] else { break }
                // один раз сохраняем город и его точку
                departureCityEntity.cityId = cityId
                departureCityEntity.cityTitle = cityTitle
                departureCityEntity.countryTitle = countryTitle
                departureCityEntity.districtTitle = districtTitle
                departureCityEntity.regionTitle = regionTitle
                departureCityEntity.date = NSDate()
                // create city point
                departureCityPointEntity.latitude = latitude
                departureCityPointEntity.longitude = longitude
                departureCityEntity.point = departureCityPointEntity
                
                do {
                    checkDigit += 1
                    try departureCityEntity.managedObjectContext?.save()
                    print("saved in the core data", checkDigit)
                } catch let error as NSError {
                    print("Cannot to save in core data, \(error), \(error.userInfo)")
                }
                
//                for station in stations {
//                    guard let countryTitle = station["countryTitle"] as? String else { break }
//                    guard let stationPoint = station["point"] as? [String : AnyObject] else { break }
//                    guard let longitude = stationPoint["longitude"] as? Double else { break }
//                    guard let latitude = stationPoint["latitude"] as? Double else { break }
//                    guard let districtTitle = station["districtTitle"] as? String  else { break }
//                    guard let cityId = station["cityId"] as? NSNumber else { break }
//                    guard let cityTitle = station["cityTitle"] as? String else { break }
//                    guard let regionTitle = station["regionTitle"] as? String else { break }
//                    guard let stationId = station["stationId"] as? NSNumber else { break }
//                    guard let stationTitle = station["stationTitle"] as? String else { break }
////                    // for station
////                    @NSManaged var cityId: NSNumber?
////                    @NSManaged var cityTitle: String?
////                    @NSManaged var countryTitle: String?
////                    @NSManaged var districtTitle: String?
////                    @NSManaged var regionTitle: String?
////                    @NSManaged var stationId: NSNumber?
////                    @NSManaged var stationTitle: String?
////                    @NSManaged var city: DepartureCity?
////                    @NSManaged var point: DepartureStationPoint?
//                }
//                print("city")
            }
//            Sync.changes(departureCity, inEntityNamed: "DepartureCity", dataStack: dataStack) { (error) -> Void in
//                if error != nil {
//                    print(error?.localizedDescription)
//                }
//            }
        } else {
            print("there is an error in departureCity")
        }
        
//        if let hostCity = json["citiesTo"] as? [[String : AnyObject]] {
////            Sync.changes(hostCity, inEntityNamed: "HostCity", dataStack: dataStack) { (error) -> Void in
////                if error != nil {
////                    print(error?.localizedDescription)
////                }
////            }
//        } else {
//            print("there is an error in host city")
//        }
    }
    
    private func entity(name: String, managedObjectContext: NSManagedObjectContext) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext)
    }
}