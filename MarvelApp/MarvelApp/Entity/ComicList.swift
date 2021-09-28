//
//  ComicList.swift
//  MarvelApp
//
//  Created by Jesus Parada on 27/09/21.
//

import Foundation

class ComicList: Decodable {

    var comics: [Comic]
    
    enum CodingKeys: String, CodingKey  {
        case data
        case results
    }
    
    init() {
        comics = []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        comics = try data.decodeIfPresent([Comic].self, forKey: .results) ?? []
    }
}
