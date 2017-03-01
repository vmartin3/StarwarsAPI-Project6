import Foundation

//Array holding all characters and their details
var allStarships: [EntityDetails] = []

//Top Level Structure holding the Array of Dictionaries with all charaacter details
struct StarshipWrapper{
    var massStarshipDictionaries: [String:AnyObject]?
}

//Iterates through each dictionary or character and creates a CharacterDetail object for each one
extension StarshipWrapper: JSONDecodableTopLevel {
    init?(JSON: [[String : AnyObject]]) {
        if let starshipDictionary = JSON as? [[String:AnyObject]] {
            for starship in starshipDictionary {
                let starwarsStarship = EntityDetails(JSON: starship, type: .Starships)
                allStarships.append(starwarsStarship!)
            }
        }
    }
}

struct StarshipDetails {
    var name: String?
    var make: String?
    var cost: String?
    var length: String?
    var type: String?
    var crewSize: String?
}
