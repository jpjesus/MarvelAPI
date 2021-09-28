//
//  MarvelCharacterViewModel.swift
//  MarvelApp
//
//  Created by Jesus Parada on 27/09/21.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

final class MarvelCharacterViewModel: MarvelCharacterViewModelProtocol {
    
    private let provider: MoyaProvider<MarvelProvider>
    var character: Character
    
    init(with provider: MoyaProvider<MarvelProvider>, character: Character) {
        self.character = character
        self.provider = provider
    }
    
    func getComicsInfo() -> Observable<[Comic]> {
        return provider.rx.request(.getComics(id: character.id))
            .asObservable()
            .map(ComicList.self)
            .retry()
            .flatMap({ list -> Observable<[Comic]> in
                return Observable.just(list.comics)
            })
           
    }
    
    func showExternalInfo(with url: String) {
    }
}
