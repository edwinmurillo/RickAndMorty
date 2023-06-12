//
//  CharacterInfo.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 11/06/23.
//

import Foundation
import ObjectMapper

class CharacterCollectionInfo: CollectionInfo {
    var nextPage: String?
    var count: Int = 0
    var results: [CharacterInfo] = []
    
    init() {}
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        results <- map["results"]
        count <- map["info.count"]
        nextPage <- map["info.next"]
    }
}

class CharacterInfo: Info {
    var id: Int = 0
    var name: String = ""
    var status: String = ""
    var species: String = ""
    var gender: String = ""
    var origin: String = ""
    var location: String = ""
    var thumbnail: URL?
    
    init() {}

    required init?(map: Map){}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
        species <- map["species"]
        gender <- map["gender"]
        origin <- map["origin.name"]
        location <- map["location.name"]
        thumbnail <- (map["image"], URLTransform())
    }
}
