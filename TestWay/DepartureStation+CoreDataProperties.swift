//
//  DepartureStation+CoreDataProperties.swift
//  TestWay
//
//  Created by Alexsander  on 3/18/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DepartureStation {

    @NSManaged var cityId: NSNumber?
    @NSManaged var cityTitle: String?
    @NSManaged var countryTitle: String?
    @NSManaged var districtTitle: String?
    @NSManaged var regionTitle: String?
    @NSManaged var remoteID: String?
    @NSManaged var stationId: NSNumber?
    @NSManaged var stationTitle: String?
    @NSManaged var city: DepartureCity?
    @NSManaged var point: DepartureStationPoint?

}
