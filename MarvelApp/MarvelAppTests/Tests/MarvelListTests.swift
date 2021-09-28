//
//  MarvelListTests.swift
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

class MarvelListTests: XCTestCase {
    
    private var navigation: UINavigationController? = UINavigationController()
    private var viewModel: MarvelListViewModelProtocol?
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        viewModel = MarvelListViewModel(with:
                                        MoyaProvider<MarvelProvider>(stubClosure: MoyaProvider<MarvelProvider>.immediatelyStub))
    }
    
    func test_getSearchCharacterExpectEqualTo() {
        
        var characters: [Character] = []
        
        let expectedCharacterCount = 1
        let expectedSearchedCharacterName = "Cyclops"
        let expectedSearchedCharacterID = 1009257
        
        let expectation = self.expectation(description: "search for character/s")
        
        viewModel?.searchMarvelCharacter(with: "Cycl")
            .subscribe(onNext: { list in
                characters = list
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        guard let character = characters.first else {
            XCTFail("list cant be nil")
            return
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(characters.count, expectedCharacterCount)
        XCTAssertEqual(character.name, expectedSearchedCharacterName)
        XCTAssertEqual(character.id, expectedSearchedCharacterID)
    }
    
    
    func test_geAllMarvelCharactersExpectEqualTo() {
        
        var characters: [Character] = []
        
        let expectedCharacterCount = 20
        let expectedLastCharacterName = "Air-Walker (Gabriel Lan)"
        let expectedLastCharacterID = 1011136
        
        let expectation = self.expectation(description: "fecth characters")
        
        viewModel?.getAllMarvelCharacters()
            .subscribe(onNext: { list in
                characters = list
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        guard let lastCharacter = characters.last else {
            XCTFail("list cant be nil")
            return
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(characters.count, expectedCharacterCount)
        XCTAssertEqual(lastCharacter.name, expectedLastCharacterName)
        XCTAssertEqual(lastCharacter.id, expectedLastCharacterID)
    }
    
    func test_CharacterViewControllerColletionExpectEqualTo() {
        
        guard let vm = viewModel else {
            XCTFail("view model should be nil")
            return
        }
        
        let sut = MarvelListViewController(with: vm)
        navigation?.setViewControllers([sut], animated: true)
        
        guard let collectionView: UICollectionView = Mirror(reflecting: sut)
            .descendant("collectionView") as? UICollectionView else {
                return
        }
        XCTAssertEqual(collectionView.visibleCells.count, 20)
    }
    
    override func tearDown() {
        super.tearDown()
        navigation = nil
    }
}
