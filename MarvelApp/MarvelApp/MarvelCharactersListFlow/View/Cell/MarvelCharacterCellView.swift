//
//  MarvelCharacterCellView.swift
//  MarvelApp
//
//  Created by Jesus Parada on 26/09/21.
//

import Foundation
import UIKit

final class MarvelCharacterCellView: UICollectionViewCell {
    
    lazy var cellContainerView: UIView = {
        let view = UIView()
        view.setupRoundedCorners(radius: 10)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.background
        return view
    }()
    
    lazy var characterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.primary
        return label
    }()
    
    lazy var characterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.setupRoundedCorners(radius: 16)
        return image
    }()
    
    private var character: Character?
    private var imageTask: URLSessionTask?
    static var identifier = "MarvelCharacterCellView"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        character = nil
        characterImage.image = nil
        characterLabel.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        setConstraints()
    }
    
    func setupCell(with character: Character) {
        characterLabel.text = character.name
        imageTask = characterImage.loadImage(with: character.thumbnail, size: .detail)
        self.setupBorder(width: 1.5, color: UIColor.primary)
        self.setupRoundedCorners(radius: 15)
    }
    
    private func addSubviews() {
        self.addSubview(cellContainerView)
        self.addSubview(characterLabel)
        self.addSubview(characterImage)
    }
    
    private func setConstraints() {
        setContainerConstraints()
        setPhotoImageConstraints()
        setTitleConstraints()
    }
}


private extension MarvelCharacterCellView {
    
    func setContainerConstraints() {
        cellContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        cellContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        cellContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        cellContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        cellContainerView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1).isActive = true
        cellContainerView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setPhotoImageConstraints() {
        characterImage.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: 2).isActive = true
        characterImage.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 2).isActive = true
        characterImage.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -2).isActive = true
        characterImage.heightAnchor.constraint(lessThanOrEqualTo: cellContainerView.heightAnchor, multiplier: 1).isActive = true
        characterImage.widthAnchor.constraint(lessThanOrEqualTo: cellContainerView.widthAnchor, multiplier: 1).isActive = true
    }
    
    func setTitleConstraints() {
        characterLabel.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 12).isActive = true
        characterLabel.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor, constant: 12).isActive = true
        characterLabel.centerXAnchor.constraint(equalTo: cellContainerView.centerXAnchor).isActive = true
        characterLabel.widthAnchor.constraint(lessThanOrEqualTo: cellContainerView.widthAnchor, multiplier: 1).isActive = true
        characterLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

