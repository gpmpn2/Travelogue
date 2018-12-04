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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryDescription: UILabel!
    @IBOutlet weak var entryTextBox: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var entryButton: UIButton!
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
        }
        
        title = entryTextBox.text
    }
    
    @IBAction func createEntry(_ sender: Any) {
        print(canEdit)
        
        if !canEdit && checkSave() {
            //save
            navigationController?.popViewController(animated: true)
        } else if canEdit {
            canEdit = !canEdit
            updateEntry(editable: canEdit)
        }
    }
    
    @IBAction func updateTitle(_ sender: Any) {
        title = entryTextBox.text
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
                imagePickerController.allowsEditing = false
                imagePickerController.sourceType = .camera
                present(imagePickerController, animated: true, completion: nil)
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
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            presentAlert(title: "No Camera", message: "This device has no camera.")
        } else {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func selectPhotoFromLibrary() {
        self.dismiss(animated: true, completion: nil)
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .authorized {
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        } else if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
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
    
    func updateEntry(editable: Bool) {
        if editable {
            imageView.image = entry?.image
            imageView.isUserInteractionEnabled = false
            entryTitle.text = entry?.title
            entryDescription.text = "Entry Description"
            entryTextBox.isHidden = true
            entryTextBox.text = entry?.title
            entryTextView.text = entry?.description
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
}
