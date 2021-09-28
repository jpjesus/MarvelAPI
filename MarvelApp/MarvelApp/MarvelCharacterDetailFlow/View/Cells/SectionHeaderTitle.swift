//
//  SectionHeaderTitle.swift
//  MarvelApp
//
//  Created by Jesus Parada on 28/09/21.
//

import Foundation
import UIKit

class SectionHeaderTitle: UICollectionReusableView {
    
     var label: UILabel = {
         let label: UILabel = UILabel()
         label.textColor = UIColor.primary
         label.font = UIFont.boldSystemFont(ofSize: 16)
         label.sizeToFit()
         return label
     }()
     override init(frame: CGRect) {
         super.init(frame: frame)
        setTitleLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitleLabel()
    }
    
    private func setTitleLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
