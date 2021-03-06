//
//  CharacterList.swift
//  MarvelApp
//
//  Created by Jesus Parada on 26/09/21.
//

import Foundation

struct CharacterList: Decodable {

    var characters: [Character]
    
    enum CodingKeys: String, CodingKey  {
        case data
        case results
    }
    
    init() {
        characters = []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        characters = try data.decodeIfPresent([Character].self, forKey: .results) ?? []
    }
}
