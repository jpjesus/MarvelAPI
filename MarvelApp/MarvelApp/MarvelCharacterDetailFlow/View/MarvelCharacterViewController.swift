//
//  MarvelCharacterViewController.swift
//  MarvelApp
//
//  Created by Jesus Parada on 27/09/21.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class MarvelCharacterViewController: UIViewController {
    
    // MARK: UI Elements
    private lazy var imageCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.register(CharacterImageViewCell.self,
                            forCellWithReuseIdentifier: CharacterImageViewCell.identifier)
        collection.register(MarvelCollectionContainerViewCell.self,
                            forCellWithReuseIdentifier: MarvelCollectionContainerViewCell.identifier)
        collection.register(MainCharacterInfoCellView.self,
                            forCellWithReuseIdentifier: MainCharacterInfoCellView.identifier)
        collection.register(SectionHeaderTitle.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "header")
        return collection
    }()
    
    private var viewModel: MarvelCharacterViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(with viewModel: MarvelCharacterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setNavigation(viewModel.character)
        addSubviews()
        setView(with: viewModel.character)
    }
    
    func addSubviews() {
        view.addSubview(imageCollectionView)
        setImageCollectionConstraints()
    }
    
    
    func setView(with character: Character) {
        getCharacterComics()
        view.layoutIfNeeded()
    }
    
    func setNavigation(_ character: Character) {
        navigationController?.clearNavigationBackground()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = character.name
        navigationItem.titleView?.tintColor = UIColor.label
    }
    
    func getCharacterComics() {
        viewModel.getComicsInfo()
            .subscribe(onNext: { [weak self] comics in
                guard let self = self else { return }
                self.viewModel.character.comics = comics
                self.imageCollectionView.reloadData()
            }, onError: { error in
                
            }).disposed(by: disposeBag)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        imageCollectionView.reloadData()
    }
}


private extension MarvelCharacterViewController {
    
    func setImageCollectionConstraints() {
        imageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        imageCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        imageCollectionView.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
    }
}


// MARK: - Collection Flow datasource
extension MarvelCharacterViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterImageViewCell.identifier,
                                                                for: indexPath) as? CharacterImageViewCell else {
                return UICollectionViewCell(frame: .zero)
            }
            cell.setupCell(with: viewModel.character)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCharacterInfoCellView.identifier,
                                                                for: indexPath) as? MainCharacterInfoCellView else {
                return UICollectionViewCell(frame: .zero)
            }
            cell.setupCell(with: viewModel.character)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelCollectionContainerViewCell.identifier,
                                                                for: indexPath) as? MarvelCollectionContainerViewCell else {
                return UICollectionViewCell(frame: .zero)
            }
            cell.setupCell(with: viewModel.character)
            cell.clipsToBounds = true
            return cell
        }
    }
}


extension MarvelCharacterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section <= 1 {
            return .zero
        } else {
            return CGSize(width: collectionView.bounds.width, height: 30)
        }
    }
}

// MARK: - Collection Flow Layout
extension MarvelCharacterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 150)
        case 1:
            return CGSize(width: collectionView.bounds.width, height: 120)
        default:
            return CGSize(width: collectionView.bounds.width, height: 250)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                  withReuseIdentifier: "header",
                                                                                  for: indexPath) as? SectionHeaderTitle else { return UICollectionReusableView()}
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section > 1 {
            sectionHeader.label.text = "Comics"
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }
}
