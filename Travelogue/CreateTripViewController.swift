//
//  CreateTripViewController.swift
//  Travelogue
//
//  Created by Grant Maloney on 12/3/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class CreateTripViewController: UIViewController {

    @IBOutlet weak var tripTitleBox: UITextField!
    @IBOutlet weak var tripDescriptionTextView: UITextView!
    @IBOutlet weak var createTripButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        tripDescriptionTextView.layer.borderWidth = 1.0
        tripDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        tripDescriptionTextView.layer.cornerRadius = 3.0
        createTripButton.layer.cornerRadius = 3.0
        self.title = "Create Trip"
    }
    
    @IBAction func updateTitleLabel(_ sender: Any) {
        title = tripTitleBox.text
    }
    
    @IBAction func createTrip(_ sender: Any) {
        if checkSave() {
            //Save here
            navigationController?.popViewController(animated: true)
        }
    }
    
    func checkSave() -> Bool {
        if tripDescriptionTextView.text == "" {
            self.presentAlert(title: "Error", message: "You must have a description before saving!")
            return false
        } else if tripTitleBox.text == "" {
            self.presentAlert(title: "Error", message: "You must have a title before saving!")
            return false
        }
        
        return true
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
