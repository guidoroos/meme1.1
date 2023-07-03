//
//  MemeCollectionCell.swift
//  Meme1.1
//
//  Created by Guido Roos on 01/07/2023.
//

import Foundation
import UIKit

class MemeCollectionCell: UICollectionViewCell {
    // Declare any UI elements as properties of the cell
    var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Add the UI elements to the cell's content view
        contentView.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            image.widthAnchor.constraint(equalToConstant: 120),
            image.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}
