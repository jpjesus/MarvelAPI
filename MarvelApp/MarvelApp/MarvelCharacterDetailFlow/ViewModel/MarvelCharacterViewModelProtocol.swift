//
//  MarvelCharacterViewModelProtocol.swift
//  MarvelApp
//
//  Created by Jesus Parada on 27/09/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol MarvelCharacterViewModelProtocol {
    
    var character: Character { get set }
    var wikiUrl: String { get }
    
    func getComicsInfo() -> Observable<[AdditionalInfo]>
    func getAdditionalInfo() -> Observable<Void>
    func showExternalInfo(with url: String, navigation: UINavigationController?)
}
