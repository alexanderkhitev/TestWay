//
//  CoreDataUtilits.swift
//  TestWay
//
//  Created by Alexsander  on 3/20/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class CoreDataUtilits {
    
    // MARK: - var and let
    private static let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    static let managedObjectContext = appDelegate.managedObjectContext
    
    static let selectedDepartureStation = NSEntityDescription.insertNewObjectForEntityForName("SelectedDepartureStation", inManagedObjectContext: managedObjectContext) as! SelectedDepartureStation
    
    static let selectedDepartureStationPoint = NSEntityDescription.insertNewObjectForEntityForName("SelectedDepartureStationPoint", inManagedObjectContext: managedObjectContext) as! SelectedDepartureStationPoint
}