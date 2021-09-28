//
//  MarvelDetailTests.swift
//  MarvelAppTests
//
//  Created by Jesus Parada on 28/09/21.
//

import Foundation
import XCTest
import Moya
import RxCocoa
import RxSwift
@testable import MarvelApp

class MarvelDetailTests: XCTestCase {
    
    private var navigation: UINavigationController? = UINavigationController()
    private var viewModel: MarvelCharacterViewModel?
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        var character = Character()
        character.name = "Cyclops"
        character.id = 1009257
        viewModel = MarvelCharacterViewModel(with:
                                                MoyaProvider<MarvelProvider>(stubClosure: MoyaProvider<MarvelProvider>.immediatelyStub), character: character)
    }
    
    func test_getComicsExpectEqualTo() {
        
        var comics: [AdditionalInfo] = []
        let expectedComicsCount = 20
        let expectedFirstComicName = "X-Men: Phoenix - Warsong (2006)"
        
        let expectation = self.expectation(description: "fetch comics")
        
        viewModel?.getComicsInfo()
            .subscribe(onNext: { list in
                comics = list
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        guard let comic = comics.first else {
            XCTFail("list cant be nil")
            return
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(comics.count, expectedComicsCount)
        XCTAssertEqual(comic.name, expectedFirstComicName)
        XCTAssertFalse(comic.thumbnail.path.isEmpty)
    }
}
