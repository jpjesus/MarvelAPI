//
//  ComicList.swift
//  MarvelApp
//
//  Created by Jesus Parada on 27/09/21.
//

import Foundation

enum CollectionInfoType {
     case comics
     case events
     case series
}

class AdditionalInfoList: Decodable {

    var results: [AdditionalInfo]
    
    enum CodingKeys: String, CodingKey  {
        case data
        case results
    }
    
    init() {
        results = []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        results = try data.decodeIfPresent([AdditionalInfo].self, forKey: .results) ?? []
    }
}
