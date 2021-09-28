//
//  MarvelListViewController.swift
//  MarvelApp
//
//  Created by Jesus Parada on 26/09/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class MarvelListViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(MarvelCharacterCellView.self,
                            forCellWithReuseIdentifier: MarvelCharacterCellView.identifier)
        collection.backgroundColor = .clear
        return collection
    }()
    
    private var searchBarContainer: UIView?
    
    private var viewModel: MarvelListViewModelProtocol
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    private var searchComponent: SearchBarComponent?
    
    init(with viewModel: MarvelListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor.background
        addSubviews()
        fetchMarvelCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func addSubviews() {
        self.view.addSubview(collectionView)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        setupSearchBar()
        setCollectionConstraints()
    }
    
    private func setupSearchBar() {
        let searchComponent = SearchBarComponent(frame: .zero)
        searchComponent.base.translatesAutoresizingMaskIntoConstraints = false
        searchComponent.placeholder = "Find your marvel character"
        view.addSubview(searchComponent.base)
        self.searchComponent = searchComponent
        setSearchViewConstraints(with: searchComponent.base)
        
        searchComponent.actions.text
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                self.searchForCharacter(with: query)
            }).disposed(by: disposeBag)
        
        searchComponent.actions.didSearch
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                self.searchForCharacter(with: query)
            }).disposed(by: disposeBag)
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        fetchMarvelCharacters()
    }
    
    private func fetchMarvelCharacters() {
        self.viewModel.getAllMarvelCharacters()
            .subscribe(onNext: { [weak self] characters in
                guard let self = self else { return }
                self.viewModel.characters = characters
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func searchForCharacter(with query: String) {
        if query.count >= viewModel.minimumChars {
            self.viewModel.searchMarvelCharacter(with: query)
                .subscribe(onNext: { [weak self] characters in
                    guard let self = self else { return }
                    self.viewModel.characters = characters
                    self.collectionView.reloadData()
                }, onError: { error in
                    
                }).disposed(by: disposeBag)
        }
    }
    
    private func setSearchViewConstraints(with view: UIView) {
        view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        view.heightAnchor.constraint(equalToConstant: 56).isActive = true
        view.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 1).isActive = true
        view.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -15).isActive = true
    }
    
    private func setCollectionConstraints() {
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        collectionView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 1).isActive = true
    }
}

// MARK: - Collection Datasource
extension MarvelListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelCharacterCellView.identifier,
                                                            for: indexPath) as? MarvelCharacterCellView else {
            return UICollectionViewCell(frame: .zero)
        }
        cell.setupCell(with: viewModel.characters[indexPath.row])
        return cell
    }
}

// MARK: - Collection Delegate
extension MarvelListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.characters.count - 1 &&
            viewModel.displayMode == .allCharacters {
            viewModel.fetchMarvelCharacters()
                .subscribe(onNext: { [weak self] characters in
                    guard let self = self else { return }
                    self.viewModel.characters.append(contentsOf: characters)
                    collectionView.performBatchUpdates({
                        collectionView.reloadSections([0])
                    })
                }).disposed(by: disposeBag)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showDetailCharacter(with: viewModel.characters[indexPath.row], navigation: navigationController)
    }
}

// MARK: - Collection Flow Layout
extension MarvelListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 150)
    }
}
