//
//  RobotCollectionViewCell.swift
//  RoboGallery
//
//  Created by Melissa Hanson on 1/13/24.
//

import UIKit

class RobotCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RobotCollectionViewCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "questionmark")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .systemGray3
        return iv
    }()
    
    func configure(image: UIImage) {
        imageView.image = image
        setUpUI()
    }
    
    private func setUpUI() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
