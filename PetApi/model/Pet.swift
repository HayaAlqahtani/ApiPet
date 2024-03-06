//
//  pet.swift
//  PetApi
//
//  Created by Haya Alqahtani on 04/03/2024.
//

import Foundation
struct Pet: Codable{
    
    let id: Int?
    let name: String
    let adopted: Bool
    let image: String
    let age: Int
    let gender: String


}
