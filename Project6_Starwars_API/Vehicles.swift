//
//  Vehicles.swift
//  Project6 -APIs
//
//  Created by Vernon G Martin on 2/5/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import Foundation

//Array holding all characters and their details
var allVehicles: [EntityDetails] = []

//Top Level Structure holding the Array of Dictionaries with all charaacter details
struct VehicleWrapper{
    var massVehicleDictionaries: [String:AnyObject]?
}

//Iterates through each dictionary or character and creates a CharacterDetail object for each one
extension VehicleWrapper: JSONDecodableTopLevel {
    init?(JSON: [[String : AnyObject]]) {
        if let vehicleDictionary = JSON as? [[String:AnyObject]] {
            for vehicle in vehicleDictionary {
                let starwarsVehicle = EntityDetails(JSON: vehicle, type: .Vehicles)
                allVehicles.append(starwarsVehicle!)
            }
        }
    }
}

struct VehicleDetails {
    var name: String?
    var make: String?
    var cost: String?
    var length: String?
    var type: String?
    var crewSize: String?
}
