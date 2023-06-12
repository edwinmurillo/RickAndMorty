//
//  EpisodeInfo.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 11/06/23.
//

import Foundation
import ObjectMapper

class EpisodeCollectionInfo: CollectionInfo {
    var nextPage: String?
    var count: Int = 0
    var results: [EpisodeInfo] = []
    
    init() {}
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        results <- map["results"]
        count <- map["info.count"]
        nextPage <- map["info.next"]
    }
}

class EpisodeInfo: Info {
    var id: Int = 0
    var name: String = ""
    var airDate: String = ""
    var episode: String = ""

    required init?(map: Map){}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        airDate <- map["air_date"]
        episode <- map["episode"]
    }
}
