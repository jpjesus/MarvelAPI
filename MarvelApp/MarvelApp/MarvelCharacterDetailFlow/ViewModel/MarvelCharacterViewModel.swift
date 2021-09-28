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
    var wikiUrl: String {
        let urlInfo = character.externalInfo.first(where: { $0.linkType == "wiki" })?.url
        return urlInfo ?? ""
    }
    
    init(with provider: MoyaProvider<MarvelProvider>, character: Character) {
        self.character = character
        self.provider = provider
    }
    
    func getComicsInfo() -> Observable<[AdditionalInfo]> {
        return provider.rx.request(.getComics(id: character.id))
            .asObservable()
            .map(AdditionalInfoList.self)
            .retry()
            .flatMap({ list -> Observable<[AdditionalInfo]> in
                return Observable.just(list.results)
            })
    }
    
    func getAdditionalInfo() -> Observable<Void> {
        return provider.rx.request(.getEvents(id: character.id))
            .asObservable()
            .map(AdditionalInfoList.self)
            .retry()
            .flatMap({ [weak self] list -> Observable<Void> in
                guard let self = self else { return  .just(())}
                self.character.events = list.results
                return self.getSeries()
            })
    }
    
    func getSeries() -> Observable<Void> {
        return provider.rx.request(.getSeries(id: character.id))
            .asObservable()
            .map(AdditionalInfoList.self)
            .retry()
            .flatMap({ [weak self] list ->Observable<Void> in
                guard let self = self else { return  .just(())}
                self.character.series = list.results
                return Observable.just(())
            })
    }
    
    func showExternalInfo(with url: String, navigation: UINavigationController?) {
        guard let url = URL(string: url) else { return }
        let vc = MarvelWebViewController(url: url)
        navigation?.modalPresentationStyle = .fullScreen
        navigation?.pushFadeAnimation(viewController: vc)
    }
}
