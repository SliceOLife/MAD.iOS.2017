//
//  TableViewController.swift
//  Airports
//
//  Created by Jordi van Hoorn on 9/11/17.
//  Copyright © 2017 Jordi. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var airports : [Airport] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let airportHandler = AirportHandler.init(for: "airports")
        airports = airportHandler.getAirportData()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return airports.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "airportCell", for: indexPath) as! AirportTableViewCell
        
        let airport = airports[indexPath.row]
        cell.airportName.text = "\(airport.airportName) (\(airport.icao))"
        cell.airportLocation.text = airport.airportLocation
        
        return cell
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDetailSegue" {
            if let destination = segue.destination as? detailViewController {
                let index = self.tableView.indexPathForSelectedRow?.row
                let airport = self.airports[index!]
                
                destination.airport = airport
            }
        }
    }
    
}
