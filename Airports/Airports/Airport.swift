//
//  Airport.swift
//  Airports
//
//  Created by Jordi van Hoorn on 9/11/17.
//  Copyright © 2017 Jordi. All rights reserved.
//

import MapKit

struct Airport {
    let icao: String
    let airportName: String
    let airportLocation: String
    let locationData: CLLocation
    
    
    init(icao: String, name: String, location: String, latitude: Double, longitude: Double) {
        self.icao = icao
        self.airportName = name
        self.airportLocation = location
        self.locationData = CLLocation(latitude: latitude, longitude: longitude)
    }
}
