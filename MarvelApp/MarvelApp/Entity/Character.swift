//
//  Character.swift
//  MarvelApp
//
//  Created by Jesus Parada on 25/09/21.
//

import Foundation

struct Character: Decodable {
    
    var id: Int
    var name: String
    var description: String
    var comics: [AdditionalInfo] = []
    var events: [AdditionalInfo] = []
    var series: [AdditionalInfo] = []
    var externalInfo: [ExternalLinks]
    var thumbnail: MarvelImage
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case thumbnail
        case urls
    }
    
    init() {
        id = 0
        thumbnail = MarvelImage()
        name = ""
        description = ""
        externalInfo = []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id =  try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        thumbnail = try container.decodeIfPresent(MarvelImage.self, forKey: .thumbnail) ?? MarvelImage()
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        externalInfo = try container.decodeIfPresent([ExternalLinks].self, forKey: .urls) ?? []
    }
}
