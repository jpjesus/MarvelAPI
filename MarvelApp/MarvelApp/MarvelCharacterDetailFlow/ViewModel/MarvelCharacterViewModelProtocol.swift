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
    
    func getComicsInfo() -> Observable<[Comic]>
    func showExternalInfo(with url: String)
}
