//
//  ExternalLinks.swift
//  MarvelApp
//
//  Created by Jesus Parada on 25/09/21.
//

import Foundation

struct ExternalLinks: Decodable {
    
    var linkType: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case url
    }
    
    init() {
        linkType = ""
        url = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        linkType = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
}
