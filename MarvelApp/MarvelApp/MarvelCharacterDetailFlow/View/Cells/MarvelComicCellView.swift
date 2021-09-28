//
//  MarvelComicCellView.swift
//  MarvelApp
//
//  Created by Jesus Parada on 27/09/21.
//

import Foundation
import UIKit

final class MarvelComicCellView: UICollectionViewCell {
    
    lazy var cellContainerView: UIView = {
        let view = UIView()
        view.setupRoundedCorners(radius: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.background
        return view
    }()
    
    lazy var comicLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 8)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.primary
        return label
    }()
    
    lazy var comicImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    private var comic: Comic?
    private var imageTask: URLSessionTask?
    static var identifier = "MarvelComicCellView"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        comic = nil
        comicImage.image = nil
        comicLabel.text = ""
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
    
    func setupCell(with comic: Comic) {
        comicLabel.text = comic.name
        imageTask = comicImage.loadImage(with: comic.thumbnail, size: .detail)
        self.setupBorder(width: 1.5, color: UIColor.primary)
        self.setupRoundedCorners(radius: 15)
    }
    
    private func addSubviews() {
        self.addSubview(cellContainerView)
        self.addSubview(comicLabel)
        self.addSubview(comicImage)
    }
    
    private func setConstraints() {
        setContainerConstraints()
        setPhotoImageConstraints()
        setTitleConstraints()
    }
}

private extension MarvelComicCellView {
    
    func setContainerConstraints() {
        cellContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        cellContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        cellContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        cellContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        cellContainerView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1).isActive = true
        cellContainerView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setPhotoImageConstraints() {
        comicImage.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: 4).isActive = true
        comicImage.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 4).isActive = true
        comicImage.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -4).isActive = true
    }
    
    func setTitleConstraints() {
        comicLabel.topAnchor.constraint(equalTo: comicImage.bottomAnchor, constant: 12).isActive = true
        comicLabel.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor, constant: -5).isActive = true
        comicLabel.centerXAnchor.constraint(equalTo: cellContainerView.centerXAnchor).isActive = true
        comicLabel.widthAnchor.constraint(lessThanOrEqualTo: cellContainerView.widthAnchor, multiplier: 1).isActive = true
        comicLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

