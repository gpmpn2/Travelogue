//
//  CreateEntryViewController.swift
//  Travelogue
//
//  Created by Grant Maloney on 12/3/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import Photos

class CreateEntryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var entry: Entry?
    var trip: Trip?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryDescription: UILabel!
    @IBOutlet weak var entryTextBox: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var entryButton: UIButton!
    @IBOutlet weak var deleteEntryButton: UIButton!
    var canEdit = true
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        
        entryTextView.layer.borderWidth = 1.0
        entryTextView.layer.borderColor = UIColor.lightGray.cgColor
        entryTextView.layer.cornerRadius = 3.0
        entryButton.layer.cornerRadius = 3.0
        imageView.isUserInteractionEnabled = true
        
        let tapImageView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.chooseImage))
        
        imageView.addGestureRecognizer(tapImageView)
        
        if entry != nil {
            updateEntry(editable: canEdit)
        } else {
            canEdit = false
            deleteEntryButton.isHidden = true
        }
        
        title = entryTextBox.text
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @IBAction func createEntry(_ sender: Any) {
        if !canEdit && checkSave() {
            saveEntry()
        } else if canEdit {
            canEdit = !canEdit
            updateEntry(editable: canEdit)
        }
    }
    
    func saveEntry() {
        if let title = entryTextBox.text, let image = imageView.image, let trip = trip {
            
            if entry == nil {
                entry = Entry(title: title, desc: entryTextView.text, image: image, trip: trip)
            } else {
                entry?.update(title: title, desc: entryTextView.text, image: image, trip: trip)
            }

            if let entry = entry {
                do {
                    let managedObjectContext = entry.managedObjectContext
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
    
    @IBAction func updateTitle(_ sender: Any) {
        title = entryTextBox.text
    }
    
    @IBAction func deleteEntry(_ sender: Any) {
        deleteEntry()
    }
    
    @objc
    func chooseImage() {
        let alert = UIAlertController(title: "Choose Option", message: "Upload photo from which location?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { camera in
            self.takePhotoWithCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { photos in
            self.selectPhotoFromLibrary()
        }))
        self.present(alert, animated: true)
    }
    
    func takePhotoWithCamera() {
        self.dismiss(animated: true, completion: nil)
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
                presentAlert(title: "No Camera", message: "This device has no camera.")
            } else {
                self.imagePickerController.allowsEditing = false
                self.imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
                        self.presentAlert(title: "No Camera", message: "This device has no camera.")
                    } else {
                        self.imagePickerController.allowsEditing = false
                        self.imagePickerController.sourceType = .camera
                        self.present(self.imagePickerController, animated: true, completion: nil)
                    }
                } else {
                    print("User is not allowing access to camera!")
                }
            })
        }
    }
    
    func selectPhotoFromLibrary() {
        self.dismiss(animated: true, completion: nil)
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .authorized {
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        } else if photos == .notDetermined || photos == .denied {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    self.imagePickerController.allowsEditing = false
                    self.imagePickerController.sourceType = .photoLibrary
                    self.present(self.imagePickerController, animated: true, completion: nil)
                } else {
                    print("User is not allowing access to photos!")
                }
            })
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func deleteEntry() {
        if let entry = entry {
            if let managedObjectContext = entry.managedObjectContext {
                managedObjectContext.delete(entry)
                
                do {
                    try managedObjectContext.save()
                    navigationController?.popViewController(animated: true)
                } catch {
                    createFailAlert(message: "Entry failed to delete", error: "Error", parent: self)
                }
            }
        }
    }
    
    func updateEntry(editable: Bool) {
        deleteEntryButton.isHidden = false
        if editable {
            if let imageData = entry?.image as Data? {
                imageView.image = UIImage(data: imageData)
            }
            imageView.isUserInteractionEnabled = false
            entryTitle.text = entry?.title
            entryDescription.text = "Entry Description"
            entryTextBox.isHidden = true
            entryTextBox.text = entry?.title
            entryTextView.text = entry?.desc
            entryTextView.isUserInteractionEnabled = false
            entryButton.setTitle("Edit Entry", for: .normal)
        } else {
            imageView.isUserInteractionEnabled = true
            entryButton.setTitle("Create Entry", for: .normal)
            entryTextView.isEditable = true
            entryTextView.isUserInteractionEnabled = true
            entryDescription.text = "Enter Entry Description"
            entryTextBox.isHidden = false
            entryTitle.text = "Enter Entry Title"
        }
    }
    
    func checkSave() -> Bool {
        if entryTextBox.text == "" {
            self.presentAlert(title: "Error", message: "You must have a title before saving!")
            return false
        } else if entryTextView.text == "" {
            self.presentAlert(title: "Error", message: "You must have a description before saving!")
            return false
        } else if imageView.image == nil {
            self.presentAlert(title: "Error", message: "You must have an image before saving!")
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= ((keyboardSize.height) - 65)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += ((keyboardSize.height) + 65)
            }
        }
    }
}
