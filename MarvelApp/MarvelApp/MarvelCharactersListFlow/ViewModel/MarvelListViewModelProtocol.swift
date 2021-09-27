//
//  MarvelListViewModelProtocol.swift
//  MarvelApp
//
//  Created by Jesus Parada on 25/09/21.
//

import Foundation
import RxCocoa
import UIKit
import RxSwift

protocol MarvelListViewModelProtocol {
    
    var characters: [Character] { get set }
    var displayMode: ListChoice { get set }
    var minimumChars: Int { get set }
    
    func getAllMarvelCharacters() -> Observable<[Character]>
    func fetchMarvelCharacters() -> Observable<[Character]>
    func searchMarvelCharacter(with query: String) -> Observable<[Character]>
    func showDetailCharacter(with character: Character, navigation: UINavigationController?)
}
