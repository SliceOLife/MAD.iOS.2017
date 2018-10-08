//
//  detailViewController.swift
//  Airports
//
//  Created by Jordi van Hoorn on 9/11/17.
//  Copyright © 2017 Jordi. All rights reserved.
//

import UIKit
import MapKit

class detailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    var airport: Airport?
    var base_airport: Airport?
    
    let base_icao = "EHAM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let airportService = AirportHandler.init(with: "airports")
        self.base_airport = airportService.getAirport(ByICAO: base_icao)
        
        if let airport = self.airport, let base_airport = self.base_airport {
            let countryName = Locale.current.localizedString(forRegionCode: airport.airportCountry) ?? ""
            nameLabel.text = airport.airportName
            locationLabel.text = "\(airport.airportLocation), \(countryName)"
            
            let distance = self.calculateDistance(between: airport, and: base_airport)
            self.setDistanceLabel(distance: distance)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let airport = self.airport, let base_airport = self.base_airport {
            setMapKitAnnotationAt(location: airport.locationData, title: airport.airportName, subtitle: airport.icao)
            setMapKitAnnotationAt(location: base_airport.locationData, title: base_airport.airportName, subtitle: base_airport.icao)
            drawGreatCirlce(between: airport, and: base_airport)
            centerMapLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMapKitAnnotationAt(location: CLLocation, title: String, subtitle: String) {
        let pinAnnotation = MKPointAnnotation()
        pinAnnotation.coordinate = location.coordinate
        pinAnnotation.title = title
        pinAnnotation.subtitle = subtitle
        mapView.addAnnotation(pinAnnotation)
    }
    
    func centerMapLocation() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func centerMapOnLocationAt(location: CLLocation, radius: Double) {
        let regionRadius: CLLocationDistance = radius
        let coordinateRegion = MKCoordinateRegion.init(
            center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius )
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setDistanceLabel(distance: Double){
        // TODO: Localization
        let intDistance = Int(distance)
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = formatter.string(from: NSNumber.init(value: intDistance / 1000))
        
        distanceLabel.text = "Distance from \(self.base_airport!.icao): \(formattedNumber!)km"
    }
    
    func calculateDistance(between airport1: Airport, and airport2: Airport) -> Double {
        return airport1.locationData.distance(from: airport2.locationData)
    }
    
    func drawGreatCirlce(between airport1: Airport, and airport2: Airport) {
        let points = [airport1.locationData.coordinate, airport2.locationData.coordinate]
        let geodesic = MKGeodesicPolyline(coordinates: points, count: points.count)
        mapView.addOverlay(geodesic)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.blue
        
        return renderer
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

