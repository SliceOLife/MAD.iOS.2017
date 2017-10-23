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
    
    init(with dbPath: String) {
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
        let country = Expression<String>("iso_country")
        
        var airports : [Airport] = []
        
        for airport in try! dbConn.prepare(airportsTable.order(icao.asc)) {
            airports.append(
                Airport(icao: airport[icao], name: airport[name], location: airport[location], country: airport[country], latitude: airport[latitude], longitude: airport[longitude]))
        }
        
        return airports
    }
    
    func getAirport(ByICAO icao_param: String) -> Airport? {
        let airportsTable = Table("airports")
        
        let icao = Expression<String>("icao")
        let name = Expression<String>("name")
        let location = Expression<String>("municipality")
        let latitude = Expression<Double>("latitude")
        let longitude = Expression<Double>("longitude")
        let country = Expression<String>("iso_country")
        
        var airport: Airport?
        
        if let dbAirport = try! dbConn.pluck(airportsTable.filter(icao == icao_param)) {
            airport = Airport(icao: dbAirport[icao], name: dbAirport[name], location: dbAirport[location], country: dbAirport[country], latitude: dbAirport[latitude], longitude: dbAirport[longitude])
        }
        
        return airport;
    }
}
