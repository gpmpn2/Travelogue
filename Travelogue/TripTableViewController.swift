//
//  TripTableViewController.swift
//  Travelogue
//
//  Created by Grant Maloney on 12/3/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

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
    
        let entries: [Entry] = [Entry(title: "Rain", description: "An image of rain", date: Date(timeIntervalSinceNow: 0), image: UIImage(named: "rain")!), Entry(title: "Wind", description: "An image of wind", date: Date(timeIntervalSinceNow: 0), image: UIImage(named: "wind")!), Entry(title: "Night", description: "An image of night", date: Date(timeIntervalSinceNow: 0), image: UIImage(named: "night")!), Entry(title: "Day", description: "An image of day", date: Date(timeIntervalSinceNow: 0), image: UIImage(named: "day")!)]
        
        travelogue.append(Trip(name: "test1", description: "test description here you can test the description.", createdDate: Date(timeIntervalSinceNow: 0), entries: entries))
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
            if let date = travelogue[row].createdDate, let name = travelogue[row].name {
                cell.tripLabel.text = name
                cell.createdLabel.text = "Created on: \(formatter.string(from: date))"
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
                destination.entries = travelogue[row].entries
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
