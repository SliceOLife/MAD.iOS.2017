//
//  detailViewController.swift
//  Airports
//
//  Created by Jordi van Hoorn on 9/11/17.
//  Copyright © 2017 Jordi. All rights reserved.
//

import UIKit
import MapKit

class detailViewController: UIViewController {
    var airport : Airport?

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let airport = self.airport {
            centerMapOnLocationAt(location: airport.locationData)
            setMapKitAnnotationAt(location: airport.locationData, title: airport.airportName, subtitle: airport.icao)
        }
    }
    
    func setMapKitAnnotationAt(location: CLLocation, title: String, subtitle: String) {
        let pinAnnotation = MKPointAnnotation()
        pinAnnotation.coordinate = location.coordinate
        pinAnnotation.title = title
        pinAnnotation.subtitle = subtitle
        mapView.addAnnotation(pinAnnotation)
    }
    
    func centerMapOnLocationAt(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
