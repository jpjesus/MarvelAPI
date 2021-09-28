//
//  MarvelCollectionContainerViewCell.swift
//  MarvelApp
//
//  Created by Jesus Parada on 28/09/21.
//

import Foundation
import UIKit

class MarvelCollectionContainerViewCell: UICollectionViewCell {
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
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
    
    private var character: Character?
    static var identifier = "MarvelCollectionContainerViewCell"
    
    func setupCell(with character: Character) {
        self.character = character
        imageCollectionView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
    }
    
    private func addSubviews() {
        self.addSubview(imageCollectionView)
        setImageCollectionConstraints()
    }
}

extension MarvelCollectionContainerViewCell {
    func setImageCollectionConstraints() {
        imageCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        imageCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        imageCollectionView.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        imageCollectionView.heightAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1).isActive = true
    }
}

// MARK: - Collection Flow datasource
extension MarvelCollectionContainerViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return character?.comics.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelComicCellView.identifier,
                                                            for: indexPath) as? MarvelComicCellView else {
            return UICollectionViewCell(frame: .zero)
        }
        cell.setupCell(with: character?.comics[indexPath.row] ?? Comic())
        return cell
    }
}


// MARK: - Collection Flow Layout
extension MarvelCollectionContainerViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, windowScene.activationState == .foregroundActive else { return .zero }
        
        switch windowScene.interfaceOrientation {
        case .portrait:
            return CGSize(width: setWidhtSize(3, collectionViewLayout: collectionViewLayout, collectionView: collectionView), height: collectionView.bounds.height)
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
