//
//  CreateTripViewController.swift
//  Travelogue
//
//  Created by Grant Maloney on 12/3/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import CoreData

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func updateTitleLabel(_ sender: UITextField) {
        title = tripTitleBox.text
    }
    
    @IBAction func createTrip(_ sender: Any) {
        if checkSave() {
            saveTrip()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func saveTrip() {
        if let name = tripTitleBox.text {
            let trip = Trip(name: name, desc: tripDescriptionTextView.text)
            
            if let trip = trip {
                do {
                    let managedObjectContext = trip.managedObjectContext
                    try managedObjectContext?.save()
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    createFailAlert(message: "Failed to save trip", error: error as! String, parent: self)
                }
            } else {
                createFailAlert(message: "Failed to create trip", error: "Error", parent: self)
            }
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height / 2)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height / 2)
            }
        }
    }
}
