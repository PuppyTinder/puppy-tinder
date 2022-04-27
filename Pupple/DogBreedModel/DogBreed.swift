//
//  DogBreed.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/27/22.
//

import Foundation

struct DogBreed : Decodable {
    //Codeable enables the object to convert between JSON and swift data types
    let message: [String:[String]]?
}

