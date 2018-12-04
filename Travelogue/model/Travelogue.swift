//
//  Travelogue.swift
//  Travelogue
//
//  Created by Grant Maloney on 12/3/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import Foundation
import UIKit

struct Trip {
    let name: String?
    let description: String?
    let createdDate: Date?
    let entries: [Entry]
    
    init(name: String, description: String, createdDate: Date, entries: [Entry]) {
        self.name = name
        self.description = description
        self.createdDate = createdDate
        self.entries = entries
    }
}

struct Entry {
    let title: String?
    let description: String?
    let date: Date?
    let image: UIImage?
    
    init(title: String, description: String, date: Date, image: UIImage) {
        self.title = title
        self.description = description
        self.date = date
        self.image = image
    }
}
