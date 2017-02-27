//
//  Entity.swift
//  Project6_Starwars_API
//
//  Created by Vernon G Martin on 2/26/17.
//  Copyright © 2017 Treehouse Island, Inc. All rights reserved.
//

import Foundation

enum EntityOptions: String{
    case Characters = "people"
    case Vehicles = "vehicles"
    case Starships = "starships"
    
    var attribute1: String{
        switch self {
        case .Characters:
            return "Born"
        case .Starships, .Vehicles:
            return "Make"
        }
    }
    var attribute2: String{
        switch self {
        case .Characters:
            return "Home"
        case .Starships, .Vehicles:
            return "Cost"
        }
    }
    var attribute3: String{
        switch self {
        case .Characters:
            return "Height"
        case .Starships, .Vehicles:
            return "Length"
        }
    }
    var attribute4: String{
        switch self {
        case .Characters:
            return "Eyes"
        case .Starships, .Vehicles:
            return "Class"
        }
    }
    var attribute5: String{
        switch self {
        case .Characters:
            return "Hair"
        case .Starships, .Vehicles:
            return "Crew"
        }
    }

}

struct EntityDetails {
    var attribute1: String?
    var attribute2: String?
    var attribute3: Double?
    var attribute4: String?
    var attribute5: String?
    var attribute6: String?
}

extension EntityDetails: JSONDecodable {
    init?(JSON: [String : AnyObject], type: EntityOptions) {
        switch type{
        case .Characters:
            guard let dateOfBirth = JSON["birth_year"] as? String,
                let home = JSON["homeworld"] as? String,
                let height = JSON["height"] as? String,
                let eyeColor = JSON["eye_color"] as? String,
                let name = JSON["name"] as? String,
                let hairColor = JSON["hair_color"] as? String else {
                    return nil
            }
            self.attribute1 = dateOfBirth
            self.attribute2 = home
            self.attribute3 = Double(height)
            self.attribute4 = eyeColor
            self.attribute5 = hairColor
            self.attribute6 = name
        case .Vehicles:
            guard let name = JSON["name"] as? String,
                make = JSON["model"] as? String,
                let cost = JSON["cost_in_credits"] as? String,
                let length = JSON["length"] as? String,
                let type = JSON["vehicle_class"] as? String,
                let crewSize = JSON["crew"] as? String else {
                    return nil
            }
            self.attribute6 = name
            self.attribute1 = make
            self.attribute2 = cost
            self.attribute3 = Double(length)
            self.attribute4 = type
            self.attribute5 = crewSize
        case .Starships:
            guard let name = JSON["name"] as? String,
                make = JSON["model"] as? String,
                let cost = JSON["cost_in_credits"] as? String,
                let length = JSON["length"] as? String,
                let type = JSON["starship_class"] as? String,
                let crewSize = JSON["crew"] as? String else {
                        return nil
                }
                self.attribute6 = name
                self.attribute1 = make
                self.attribute2 = cost
                self.attribute3 = Double(length)
                self.attribute4 = type
                self.attribute5 = crewSize
                }
        }
    }

func findSmallest(type: EntityOptions) -> [EntityDetails]{
    switch type {
    case .Characters:
        allCharacters = allCharacters.sort({ $0.attribute3 < $1.attribute3 })
        return allCharacters
    case .Vehicles:
        allVehicles = allVehicles.sort({ $0.attribute3 < $1.attribute3 })
        return allVehicles
    case .Starships:
        allStarships = allStarships.sort({ $0.attribute3 < $1.attribute3 })
        return allStarships
}
}

