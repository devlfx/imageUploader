//
//  HeaderCollectionReusableView.swift
//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 05/04/21.
//

// Vista reutilizable para el header dle usuario, con esta vista s epuede dar ese efecto de scrollo haci abajo y que se desaparexca la foto y el botón de subir

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    // Las variables son lazy para que sean creadas hasta que se necesitan.
    // Tengo dudas sobre esto.
    
    // Usamos un delegado para llamar al picker controller
    var headerDelegate: UploadHeaderDelegate?
    // Imagen de PErfil
    lazy var userImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "placeholder")
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        return image
    }()
    // Botón de subir imagen
    lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.setTitle("Upload image", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemPink.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame:.zero)

        self.addSubview(uploadButton)
        self.addSubview(userImageView)
        self.addConstraints()
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage(tapGestureRecognizer:)))
        self.userImageView.addGestureRecognizer(tapImage)
        self.uploadButton.addTarget(self, action: #selector(didTapUploadButton), for: .touchDown)
        
        
    }
    
    func addConstraints() {
        // Los constraints se hacen respecto ala vista padre
        userImageView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4).isActive = true
        userImageView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier:0.7).isActive = true
        userImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        userImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        uploadButton.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier:0.40).isActive = true
        uploadButton.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier:0.20).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor).isActive = true
        uploadButton.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    @objc func didTapProfileImage(tapGestureRecognizer:UITapGestureRecognizer) {
        guard let headerdelegate = self.headerDelegate else { return }
        headerdelegate.uploadProfilePhoto()
    }
    
    @objc func didTapUploadButton(_ sender: UIButton){
        guard let headerdelegate = self.headerDelegate else { return }
        headerdelegate.uploadPhoto()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
