//
//  SwapiClient.swift
//  Project6_Starwars_API
//
//  Created by Vernon G Martin on 2/14/17.
//  Copyright © 2017 Treehouse Island, Inc. All rights reserved.
//

import Foundation
//MARK: - Starwars SWAPI API Set Up

//struct starwarsItemType {
//    let type: String
//    let number: Int
//}


//Creates URL Base and then endpoint based on Starwars category selected (People, Starships or Vehicles)
enum Starwars: Endpoint {
    case Endpoint(type: String)
    
    
    var baseURL: NSURL{
        return NSURL(string: "http://swapi.co/api/")!
    }
    
    var path: String{
        switch self {
        case .Endpoint(let entity):
            return "\(entity)/"
        }
    }
    
    var request: NSURLRequest{
        let url = NSURL(string: path, relativeToURL: baseURL)
        return NSURLRequest(URL: url!)
    }
}

//Class to set up API Connection - Session and session configuration
final class SwapiClient: APIClient{
    let configuration: NSURLSessionConfiguration
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.configuration)
    }()
    
    init(config: NSURLSessionConfiguration) {
        self.configuration = config
    }
    
    //Initalizing Session Config with Default Configuration
    convenience init(){
        self.init(config: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    //Fetching the Starwars Data using the Session config and Request URL that was set up
    //Attempts to parse the JSON data into the [[String:AnyObject]] format and store it in the personalDetailsDictionary
    
    func fetchStarwarsCharacterData(entity: EntityOptions, completion: (APIResult<CharacterWrapper>) -> Void){
        let request = Starwars.Endpoint(type: entity.rawValue).request
        //FIXME: print("Full Request is: \(request)")
        
        fetch(request, parse: {json -> CharacterWrapper? in
            if let personalDetailsDictionary = json["results"] as? [[String:AnyObject]]{
                //FIXME: print("Dictionary Retrieved is: \(personalDetailsDictionary)")
                return CharacterWrapper(JSON: personalDetailsDictionary)
            }
            else{
                return nil
            }
            }, completion: completion)
    }
    
    func fetchStarwarsVehicleData(entity: EntityOptions, completion: (APIResult<VehicleWrapper>) -> Void){
        let request = Starwars.Endpoint(type: entity.rawValue).request
       //FIXME: print("Full Request is: \(request)")
        
        fetch(request, parse: {json -> VehicleWrapper? in
            if let vehicleDetailsDictionary = json["results"] as? [[String:AnyObject]]{
                //print("Dictionary Retrieved is: \(personalDetailsDictionary)")
                return VehicleWrapper(JSON: vehicleDetailsDictionary)
            }
            else{
                return nil
            }
            }, completion: completion)
    }
    
    func fetchStarwarsStarshipData(entity: EntityOptions, completion: (APIResult<StarshipWrapper>) -> Void){
        let request = Starwars.Endpoint(type: entity.rawValue).request
        
        fetch(request, parse: {json -> StarshipWrapper? in
            if let starshipDetailsDictionary = json["results"] as? [[String:AnyObject]]{
                //FIXME: print("Dictionary Retrieved is: \(starshipDetailsDictionary)")
                return StarshipWrapper(JSON: starshipDetailsDictionary)
            }
            else{
                return nil
            }
            }, completion: completion)
    }
}
