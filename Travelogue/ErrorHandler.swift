//
//  ErrorHandler.swift
//  DocumentsCoreRelationships
//
//  Created by Grant Maloney on 9/28/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import Foundation
import UIKit

func createFailAlert(message: String, error: String, parent: Any){
    let alert = UIAlertController(title: message, message: error, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    if let parent = parent as? UIViewController {
        parent.present(alert, animated: true, completion: nil)
    }
    
    if let parent = parent as? UITableViewController {
        parent.present(alert, animated: true, completion: nil)
    }
}
