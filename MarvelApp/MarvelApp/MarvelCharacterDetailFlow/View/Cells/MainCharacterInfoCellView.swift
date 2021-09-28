//
//  MainCharacterInfoCellView.swift
//  MarvelApp
//
//  Created by Jesus Parada on 28/09/21.
//

import Foundation
import UIKit

class MainCharacterInfoCellView: UICollectionViewCell {
    
    private lazy var descriptionArea: UITextView = {
        let textView = UITextView()
        textView.font =  UIFont.systemFont(ofSize: 11)
        textView.textAlignment = .left
        textView.textColor = .label
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var externalInfoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Character Wiki", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        return button
    }()

    static var identifier = "MainCharacterInfoCellView"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionArea.text = ""
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }
    
    func setupCell(with character: Character) {
        descriptionArea.text = character.description.isEmpty ? "No info available" : character.description
    }
    
    private func addSubviews() {
        self.addSubview(descriptionArea)
        self.addSubview(externalInfoButton)
    }
    
    private func setConstraints() {
        setTextAreaConstraints()
        setWikiInfoConstraints()
    }
}


private extension MainCharacterInfoCellView {
    
    func setTextAreaConstraints() {
        descriptionArea.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        descriptionArea.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        descriptionArea.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        descriptionArea.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 1).isActive = true
    }
    
    func setWikiInfoConstraints() {
        externalInfoButton.topAnchor.constraint(equalTo: descriptionArea.bottomAnchor, constant: 10).isActive = true
        externalInfoButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        externalInfoButton.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1).isActive = true
        externalInfoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
}
