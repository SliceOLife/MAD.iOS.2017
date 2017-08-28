//
//  PersonStartViewController.swift
//  ContactCard
//
//  Created by Jordi van Hoorn on 8/28/17.
//  Copyright © 2017 Jordi. All rights reserved.
//

import UIKit

class PersonStartViewController: UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(grafRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func grafRotate() {
        roundOffImageView()
    }
    
    func roundOffImageView() {
        avatarImageView.layer.borderColor = UIColor.darkGray.cgColor
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let json = try! JSONSerialization.jsonObject(with: data) as? [String: Any]
            let results = json?["results"] as? [[String: Any]]
            
            for result in results! {
                let name = result["name"] as? [String:Any]
                let firstName = name?["first"] as? String
                let lastName = name?["last"] as? String
                
                let imageData = result["picture"] as? [String:Any]
                let imageUrl = imageData?["large"] as? String
                
                DispatchQueue.main.async(execute: {
                    self.handleNewUserUpdate(firstName: firstName!, lastName: lastName!, imageUrl: imageUrl!)
                })
            }
        }
        
        task.resume()
    }
    
    
    // Handle new randomuser update
    func handleNewUserUpdate(firstName: String, lastName: String, imageUrl: String) {
        //print("Got a new user: \(name) with image URL: \(imageUrl)")
        firstNameLabel.text = firstName.capitalized
        lastNameLabel.text = lastName.capitalized
        
        let url = URL(string: imageUrl)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.avatarImageView.image = UIImage(data: data!)
                UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { self.avatarImageView.alpha = 1.0 })
            }
        }
    }
    
    
    @IBAction func refreshBtn(_ sender: Any) {
        self.avatarImageView.alpha = 0.1
        // Request a new user on button press
        requestNewUsers(amount: 1)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
