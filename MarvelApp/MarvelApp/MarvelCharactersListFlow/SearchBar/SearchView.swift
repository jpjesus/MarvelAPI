//
//  SearchView.swift
//  MarvelApp
//
//  Created by Jesus Parada on 26/09/21.
//

import UIKit

final class SearchBarImageView: UIView {

    // MARK: - Properties

    private let sizeConstant: CGFloat = 24.0

    // swiftlint:disable:next implicitly_unwrapped_optional
    override var tintColor: UIColor! {
        get { super.tintColor }
        set {
            super.tintColor = newValue
            imageView.tintColor = newValue
        }
    }

    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }

    // MARK: - UI elements

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.primerGold
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()
    }
}

// MARK: - Private implementations

private extension SearchBarImageView {

    // MARK: - UI
    func setupUI() {
        addSubview(imageView)
        setupConstraints()
        setupRoundedCorners(radius: 16)
    }

    // MARK: - Constraints
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: sizeConstant).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: sizeConstant).isActive = true
    }
    // MARK: - Gradient
    func setupGradient() {
        backgroundColor = UIColor.primerGold
    }
}
