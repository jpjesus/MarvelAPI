//
//  Comic.swift
//  MarvelApp
//
//  Created by Jesus Parada on 25/09/21.
//

import Foundation

struct Comic: Decodable {
    
    var name: String
    var description: String
    var issueNumber: Int
    var comicImages: [MarvelImage]
    var thumbnail: MarvelImage
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case issueNumber
        case thumbnail
        case images
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        thumbnail = try container.decodeIfPresent(MarvelImage.self, forKey: .thumbnail) ?? MarvelImage()
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        comicImages = try container.decodeIfPresent([MarvelImage].self, forKey: .images) ?? []
        issueNumber = try container.decodeIfPresent(Int.self, forKey: .issueNumber) ?? 0
    }
}
