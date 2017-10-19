//
//  PersonStartTableViewController.swift
//  ContactCard
//
//  Created by Jordi van Hoorn on 9/4/17.
//  Copyright © 2017 Jordi. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var personImageThumbnail: UIImageView!
}


class PersonStartTableViewController: UITableViewController {
    var persons: [ApiResults.ResultsElement] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        self.requestNewUsers(amount: 20)

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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func requestNewUsers(amount: Int) {
        let url = URL(string: "https://randomuser.me/api?results=\(amount)")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSON(data: data)
            let response = ApiResults(json: json).results
            self.persons = response
            
            print("Got \(amount) users from the RandomUser API")
            
            // Reload our Tableview to display data
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
        }
        
        task.resume()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! PersonTableViewCell
        
        let person = persons[indexPath.row]
        cell.fullNameLabel?.text = person.name.first.capitalized + " " + person.name.last.capitalized
        
        let url = URL(string: person.picture.thumbnail)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.personImageThumbnail.image = UIImage(data: data!)
            }
        }
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segPersonDetails" {
            if let destination = segue.destination as? PersonDetailViewController {
                
                
                let index = self.tableView.indexPathForSelectedRow?.row
                let person = self.persons[index!]
                
                destination.person = person
            }
        }
    }

}
