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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 4
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.register(MarvelComicCellView.self,
                            forCellWithReuseIdentifier: MarvelComicCellView.identifier)
        return collection
    }()
    
    private lazy var descriptionArea: UITextView = {
        let textView = UITextView()
        textView.font =  UIFont.systemFont(ofSize: 13)
        textView.isEditable = false
        textView.textAlignment = .left
        textView.textColor = UIColor.label
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var characterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var externalInfoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Character Wiki", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
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
        setConstraints()
        setView(with: viewModel.character)
    }
    
    func addSubviews() {
        view.addSubview(characterImage)
        view.addSubview(descriptionArea)
        view.addSubview(externalInfoButton)
        view.addSubview(imageCollectionView)
    }
    
    func setConstraints() {
        setCharacterImageConstraints()
        setTextAreaConstraints()
        setWikiInfoConstraints()
        setImageCollectionConstraints()
    }
    
    func setView(with character: Character) {
        _ = characterImage.loadImage(with: character.thumbnail, size: .detail)
        descriptionArea.text = viewModel.character.description.isEmpty ? "No Info available" : viewModel.character.description
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
    
    func setCharacterImageConstraints() {
        characterImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        characterImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        characterImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        characterImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func setTextAreaConstraints() {
        descriptionArea.isHidden = false
        descriptionArea.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 10).isActive = true
        descriptionArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        descriptionArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        descriptionArea.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setWikiInfoConstraints() {
        externalInfoButton.topAnchor.constraint(equalTo: descriptionArea.bottomAnchor, constant: 10).isActive = true
        externalInfoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        externalInfoButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        externalInfoButton.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 1).isActive = true
    }
    
    func setImageCollectionConstraints() {
        imageCollectionView.topAnchor.constraint(equalTo: externalInfoButton.bottomAnchor, constant: 10).isActive = true
        imageCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        imageCollectionView.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        imageCollectionView.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1).isActive = true
    }
}


// MARK: - Collection Flow datasource
extension MarvelCharacterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.character.comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelComicCellView.identifier,
                                                            for: indexPath) as? MarvelComicCellView else {
            return UICollectionViewCell(frame: .zero)
        }
        cell.setupCell(with: viewModel.character.comics[indexPath.row])
        cell.clipsToBounds = true
        return cell
    }
}

// MARK: - Collection Flow Layout
extension MarvelCharacterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, windowScene.activationState == .foregroundActive else { return .zero }
        
        switch windowScene.interfaceOrientation {
        case .portrait:
            return CGSize(width: 250, height: collectionView.bounds.height)
        case .landscapeLeft,
             .landscapeRight:
            return CGSize(width: setWidhtSize(3, collectionViewLayout: collectionViewLayout, collectionView: collectionView), height: collectionView.bounds.height)
        default:
            return CGSize.zero
        }
    }
    
    private func setWidhtSize(_ numberOfCells: Int, collectionViewLayout: UICollectionViewLayout, collectionView: UICollectionView) -> CGFloat {
           guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
               return .zero
           }
           let spacing = flowLayout.sectionInset.left
               + flowLayout.sectionInset.right
               + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfCells - 1))
           
           return (collectionView.bounds.width - spacing) / CGFloat(numberOfCells)
       }
}
