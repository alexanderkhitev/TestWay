//
//  HostCity+CoreDataProperties.swift
//  TestWay
//
//  Created by Alexsander  on 3/19/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HostCity {

    @NSManaged var cityId: NSNumber?
    @NSManaged var cityTitle: String?
    @NSManaged var countryTitle: String?
    @NSManaged var date: NSDate?
    @NSManaged var districtTitle: String?
    @NSManaged var regionTitle: String?
    @NSManaged var point: HostPoint?
    @NSManaged var stations: NSSet?

}
