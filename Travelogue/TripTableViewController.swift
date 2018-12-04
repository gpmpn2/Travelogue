//
//  TripTableViewController.swift
//  Travelogue
//
//  Created by Grant Maloney on 12/3/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import CoreData

class TripTableViewController: UITableViewController {

    var travelogue = [Trip]()
    var formatter = DateFormatter()
    
    @IBAction func addTrip(_ sender: Any) {
        performSegue(withIdentifier: "showCreateTrip", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTravelogue()
        tableView.reloadData()
    }
    
    func loadTravelogue() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        do {
            travelogue = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            createFailAlert(message: "Failed to load data", error: error as! String, parent: self)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travelogue.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripIdentifier", for: indexPath)

        let row = indexPath.row
        
        if let cell = cell as? TripTableViewCell {
            if let date = travelogue[row].modifiedDate, let name = travelogue[row].name {
                cell.tripLabel.text = name
                cell.createdLabel.text = "Created on: \(formatter.string(from: date))"
                cell.bgView.layer.cornerRadius = 5.0
                cell.bgView.backgroundColor = UIColor.red
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEntries", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EntryCollectionViewController {
            if let row = tableView.indexPathForSelectedRow?.row {
                destination.trip = travelogue[row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") {
            action, index in
            self.handleDelete(indexPath: indexPath)
        }
        delete.backgroundColor = UIColor.red
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") {
            action, index in
            self.handleEdit(indexPath: indexPath)
        }
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
    
    func handleEdit(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Enter a new trip name", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            return
        }))
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            
            if let updatedName = textField?.text {
                if updatedName == "" {
                    return
                } else {
                    self.travelogue[indexPath.row].update(name: updatedName)
                    
                    if let context = self.travelogue[indexPath.row].managedObjectContext {
                        do {
                            try context.save()
                        } catch {
                            createFailAlert(message: "Failed to save", error: error as! String, parent: self)
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                return
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDelete(indexPath: IndexPath) {
        if let entries = travelogue[indexPath.row].rawEntries{
            if entries.count == 0 {
                delete(indexPath: indexPath)
                return;
            }
        }
        
        let alert = UIAlertController(title: "Are you sure you want to delete?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            // Delete the row from the data source
            self.delete(indexPath: indexPath)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            return
        }))
        
        self.present(alert, animated: true)
    }
    
    func delete(indexPath: IndexPath) {
        let trip = self.travelogue[indexPath.row]
        
        if let managedObjectContext = trip.managedObjectContext {
            managedObjectContext.delete(trip)
            
            do {
                try managedObjectContext.save()
                self.travelogue.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                createFailAlert(message: "Delete failed", error: error as! String, parent: self)
            }
        }
    }
}
