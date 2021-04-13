//
//  ImageCollectionViewCell.swift
//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 02/04/21.
//

// Celda  customizada para el collection View solo tiene una imagen
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    let bg: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.clipsToBounds = true
        contentView.addSubview(bg)
        
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Falta implementar")
    }
}
