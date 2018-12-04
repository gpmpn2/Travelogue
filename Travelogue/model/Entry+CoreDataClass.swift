//
//  Entry+CoreDataClass.swift
//  Travelogue
//
//  Created by Grant Maloney on 12/4/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Entry)
public class Entry: NSManagedObject {
    var modifiedDate: Date? {
        get {
            return createdDate as Date?
        }
        set {
            createdDate = newValue as NSDate?
        }
    }
    
    convenience init?(title: String?, desc: String?, image: UIImage, trip: Trip) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate  //UIKit is needed to access UIApplication
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let title = title, title != "", let desc = desc, desc != "" else {
                return nil
        }
        self.init(entity: Entry.entity(), insertInto: managedContext)
        self.title = title
        self.desc = desc
        self.image = image.jpegData(compressionQuality: 1) as NSData?
        self.modifiedDate = Date(timeIntervalSinceNow: 0)
        self.trip = trip
    }
    
    func update(title: String?, desc: String?, image: UIImage, trip: Trip) {
        self.title = title
        self.desc = desc
        self.image = image.jpegData(compressionQuality: 1) as NSData?
        self.trip = trip
    }
}
