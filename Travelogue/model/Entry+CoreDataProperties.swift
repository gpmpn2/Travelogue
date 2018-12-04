//
//  Entry+CoreDataProperties.swift
//  Travelogue
//
//  Created by Grant Maloney on 12/4/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var createdDate: NSDate?
    @NSManaged public var image: NSData?
    @NSManaged public var trip: Trip?

}
