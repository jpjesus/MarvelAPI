//
//  MarvelImage.swift
//  MarvelApp
//
//  Created by Jesus Parada on 25/09/21.
//

import Foundation

enum ImageSize: String {
    case portraitMedium = "portrait_medium"
    case portraitLarge = "portrait_xlarge"
    case detail = "detail"
    case landscapeLarge = "landscape_large"
    case landscapeMedium = "landscape_medium"
}

struct MarvelImage: Decodable {
    
    var path: String
    var imageExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
    
    init() {
        path = ""
        imageExtension = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try container.decodeIfPresent(String.self, forKey: .path) ?? ""
        imageExtension = try container.decodeIfPresent(String.self, forKey: .imageExtension) ?? ""
    }
}
