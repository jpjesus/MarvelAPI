//
//  MarvelProvider.swift
//  MarvelApp
//
//  Created by Jesus Parada on 25/09/21.
//

import Foundation
import Moya
import CryptoKit

let apiURL = "https://gateway.marvel.com/v1/public"

enum MarvelProvider {
    case getMarvelCharacters(offset: Int, limitPerPage: Int)
    case getComics(id: Int)
    case searchMarvelCharacter(query: String)
    case getEvents(id: Int)
    case getSeries(id: Int)
    case getStories(id: Int)
}

extension MarvelProvider: TargetType {
    var baseURL: URL {
        return URL(string: apiURL) ?? URL(fileURLWithPath: "")
    }
    
    var path: String {
        switch self {
        case .getMarvelCharacters(_,_), .searchMarvelCharacter(_):
            return "characters"
        case .getComics(let id):
            return "characters/\(id)/comics"
        case .getEvents(let id):
            return "characters/\(id)/events"
        case .getSeries(let id):
            return "characters/\(id)/series"
        case .getStories(let id):
            return "characters/\(id)/stories"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .getMarvelCharacters:
            guard let url = Bundle.main.url(forResource: "MarvelListMock", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .searchMarvelCharacter:
            guard let url = Bundle.main.url(forResource: "MarvelListSearchMock", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .getEvents:
            guard let url = Bundle.main.url(forResource: "MarvelEventMock", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .getComics:
            guard let url = Bundle.main.url(forResource: "MarvelComicsMock", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        default:
            return Data()
        }
    }
    
    var task: Task {
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(MarvelProvider.privateMarvelKey)\(MarvelProvider.publicMarvelKey)".data(using: .utf8)?.md5
        switch self {
        case .getMarvelCharacters(let offset, let limitPerPage):
            let params: [String: Any] = ["limit": limitPerPage,
                                         "offset": offset,
                                         "ts": timestamp,
                                         "hash": hash ?? "",
                                         "apikey": MarvelProvider.publicMarvelKey]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getComics,.getSeries,.getEvents,.getStories:
            let params: [String: Any] = ["ts": timestamp,
                                         "hash": hash ?? "",
                                         "apikey": MarvelProvider.publicMarvelKey]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .searchMarvelCharacter(let query):
            let params: [String: Any] = ["nameStartsWith": query,
                                         "ts": timestamp,
                                         "hash": hash ?? "",
                                         "apikey": MarvelProvider.publicMarvelKey]
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
    
    static var privateMarvelKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "MarvelKeys", ofType: "plist") else {
                fatalError("Couldn't find file 'MarvelKeys.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "MARVEL_PRIVATE_KEY") as? String else {
                fatalError("Couldn't find key 'MARVEL_PRIVATE_KEY' in 'MarvelKeys.plist'.")
            }
            return value
        }
    }
}
