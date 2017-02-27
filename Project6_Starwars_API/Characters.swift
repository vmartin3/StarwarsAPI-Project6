//
//  Characters.swift
//  Project6 -APIs
//
//  Created by Vernon G Martin on 2/5/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import Foundation
//MARK: - Creating Character Objects Out of JSON Array of Dictionaries Retrieved


//Array holding all characters and their details
var allCharacters: [EntityDetails] = []

//Top Level Structure holding the Array of Dictionaries with all charaacter details
struct CharacterWrapper{
    var massCharacterDictionaries: [String:AnyObject]?
}



//Iterates through each dictionary or character and creates a CharacterDetail object for each one
extension CharacterWrapper: JSONDecodableTopLevel {
    init?(JSON: [[String : AnyObject]]) {
        if let characterDictionary = JSON as? [[String:AnyObject]] {
            for character in characterDictionary {
                let starwarsCharacter = EntityDetails(JSON: character, type: .Characters)
                allCharacters.append(starwarsCharacter!)
                //print(starwarsCharacter?.name)
            }
        }
    }
}

//Structure holding the details to be stored for each Character
struct CharacterDetails {
    var dateOfBirth: String?
    var home: String?
    var height: Double?
    var eyeColor: String?
    var hairColor: String?
    var name: String?
    
}


