//
//  CharacterImageViewCell.swift
//  MarvelApp
//
//  Created by Jesus Parada on 28/09/21.
//

import Foundation
import UIKit

class CharacterImageViewCell: UICollectionViewCell {
    
    private lazy var characterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        characterImage.image = nil
    }
    
    private var imageTask: URLSessionTask?
    static var identifier = "CharacterImageViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    func setView() {
        addSubview(characterImage)
        setCharacterImageConstraints()
    }
    
    func setupCell(with character: Character) {
        imageTask = characterImage.loadImage(with: character.thumbnail, size: .detail)
    }
    
    func setCharacterImageConstraints() {
        characterImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        characterImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        characterImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        characterImage.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        characterImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}
