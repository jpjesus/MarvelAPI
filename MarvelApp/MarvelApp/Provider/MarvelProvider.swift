//
//  MarvelProvider.swift
//  MarvelApp
//
//  Created by Jesus Parada on 25/09/21.
//

import Foundation
import Moya

let apiURL = "https://gateway.marvel.com:443/v1/public"

enum MarvelProvider {
    case getMarvelCharacters(offset: Int, limitPerPage: Int)
    case getDetailedInfo(id: Int)
}

extension MarvelProvider: TargetType {
    var baseURL: URL {
        return URL(string: apiURL) ?? URL(fileURLWithPath: "")
    }
    
    var path: String {
        switch self {
        case .getMarvelCharacters(_,_):
            return "characters"
        case .getDetailedInfo(let id):
            return "characters/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getMarvelCharacters(let offset, let limitPerPage):
            let params: [String: Any] = ["limit": limitPerPage,
                                         "offset": offset,
                                         "apikey": MarvelProvider.publicMarvelKey]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getDetailedInfo(_):
            let params: [String: Any] = ["apikey": MarvelProvider.publicMarvelKey]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    static var publicMarvelKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "MarvelKeys", ofType: "plist") else {
                fatalError("Couldn't find file 'MarvelKeys.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "MARVEL_PUBLIC_KEY") as? String else {
                fatalError("Couldn't find key 'MARVEL_PUBLIC_KEY' in 'MarvelKeys.plist'.")
            }
            return value
        }
    }
}
