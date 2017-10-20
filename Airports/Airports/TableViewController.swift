//
//  TableViewController.swift
//  Airports
//
//  Created by Jordi van Hoorn on 9/11/17.
//  Copyright © 2017 Jordi. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var groupedAirports: [String: [Airport]] = [:]
    var sections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let airportHandler = AirportHandler.init(with: "airports")
        var airports: [Airport] = airportHandler.getAirportData()
        
        airports = airportHandler.getAirportData()
        groupedAirports = Dictionary(grouping: airports, by: { airport in airport.airportCountry })
        sections = groupedAirports.keys.sorted()
        

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
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return groupedAirports[sections[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(Locale.current.localizedString(forRegionCode: sections[section]) ?? "") (\(sections[section]))"
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "airportCell", for: indexPath) as! AirportTableViewCell
        
        let airportSection = groupedAirports[sections[indexPath.section]]
        let airport = airportSection![indexPath.row]
        
        cell.airportName.text = airport.airportName
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
                let index = self.tableView.indexPathForSelectedRow
                
                let country = self.sections[index!.section]
                if let airport = self.groupedAirports[country]?[index!.row] {
                    destination.airport = airport
                }
            }
        }
    }
    
}
