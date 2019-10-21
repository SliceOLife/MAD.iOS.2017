//
//  PersonDetailViewController.swift
//  ContactCard
//
//  Created by Jordi van Hoorn on 8/28/17.
//  Copyright © 2017 Jordi. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    var person: ApiResults.ResultsElement?;
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(grafRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let person = self.person {
            handleIncomingPerson(firstName: person.name.first, lastName: person.name.last, imageUrl: person.picture.large)
        }
    }
    
    @objc func grafRotate() {
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
    
    
    // Handle new randomuser update
    func handleIncomingPerson(firstName: String, lastName: String, imageUrl: String) {
        //print("Got a new user: \(name) with image URL: \(imageUrl)")
        firstNameLabel.text = firstName.capitalized
        lastNameLabel.text = lastName.capitalized
        
        self.navigationItem.title = "\(firstName.capitalized)'s details"
        
        let url = URL(string: imageUrl)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.avatarImageView.image = UIImage(data: data!)
                UIView.animate(withDuration: 1.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { self.avatarImageView.alpha = 1.0 })
            }
        }
    }
}
