//
//  SqliteHandler.swift
//  Airports
//
//  Created by Jordi van Hoorn on 9/11/17.
//  Copyright © 2017 Jordi. All rights reserved.
//

import Foundation
import SQLite

class AirportHandler {
    var dbConn: Connection
    
    init(for dbPath: String) {
        let dbPath = Bundle.main.path(forResource: dbPath, ofType: "sqlite")
        dbConn = try! Connection(dbPath!)
    }
    
    func getAirportData() -> [Airport] {
        let airportsTable = Table("airports")
        
        let icao = Expression<String>("icao")
        let name = Expression<String>("name")
        let location = Expression<String>("municipality")
        let latitude = Expression<Double>("latitude")
        let longitude = Expression<Double>("longitude")
        
        var airports : [Airport] = []
        
        for airport in try! dbConn.prepare(airportsTable) {
            airports.append(Airport(icao: airport[icao], name: airport[name], location: airport[location], latitude: airport[latitude], longitude: airport[longitude]))
        }
        
        return airports
    }
}
