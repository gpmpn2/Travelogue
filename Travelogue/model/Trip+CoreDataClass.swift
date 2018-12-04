//
//  Trip+CoreDataClass.swift
//  Travelogue
//
//  Created by Grant Maloney on 12/4/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Trip)
public class Trip: NSManagedObject {
    var modifiedDate: Date? {
        get {
            return createdDate as Date?
        }
        set {
            createdDate = newValue as NSDate?
        }
    }
    
    convenience init?(name: String?, desc: String?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate  //UIKit is needed to access UIApplication
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "", let desc = desc, desc != "" else {
                return nil
        }
        
        self.init(entity: Trip.entity(), insertInto: managedContext)
        self.name = name
        self.desc = desc
        self.modifiedDate = Date(timeIntervalSinceNow: 0)
    }
    
    func update(name: String?, desc: String?) {
        self.name = name
        self.desc = desc
    }
    
    func update(name: String?) {
        self.name = name
    }
}
