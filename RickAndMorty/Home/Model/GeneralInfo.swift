//
//  GeneralInfo.swift
//  RickAndMorty
//
//  Created by edwin.murillo on 9/06/23.
//

import Foundation
import ObjectMapper

protocol CollectionInfo: Mappable {
    var nextPage: String? { get set }
    var count: Int { get set }
}

protocol Info: Mappable {
    var id: Int { get set }
    var name: String { get set }
}
