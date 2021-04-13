//
//  UploadPhotoViewController.swift
//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 27/03/21.
//

import UIKit
import Firebase
import CoreServices
import FirebaseUI

class UploadPhotoViewController: UIViewController {

    
    var images : [StorageReference] = []
    let storage = Storage.storage()
    var userProfileImageReference = StorageReference()
    var imageData : Data?
    var imageName : String? = ""
    var isProfilePicture = false
    
    lazy var userImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "placeholder")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    var collectionView: UICollectionView = {
        // SI no se inicializa el layout se muere y no calcula los valores requeridos para las celdas (Se ve chueco)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Upload photo"
        self.view.addSubview(collectionView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "exclamationmark.circle"), style: .done, target: self, action: #selector(didTapLogout))
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.getFilesReferences()
        self.downloadProfileImage()
        
        
        
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    // Cuando se sucita un cambio en la pantalla este método se ejecuta y se calculan las medidas.
    // Otra manera de no usar constraints.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        self.collectionView.frame = CGRect(
            x: view.left,
            y: view.top,
            width: view.width,
            height: view.height
        )
        
        
    }
    
    
    @objc func didTapLogout(_ sender: UIButton){
        
        let logoutAlert = UIAlertController(title: "Logout", message: "¿Seguro que desea cerrar la sesión?", preferredStyle: UIAlertController.Style.alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Cerrar Sesión", style: .default, handler: {
            (action: UIAlertAction!) in
            AuthManager.shared.logout {
                [weak self] in
                let mainApp = LoginNavigationController()
                mainApp.modalPresentationStyle = .fullScreen
                self?.present(mainApp, animated: true, completion: nil)
            }
        }))

        logoutAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in
        }))

        self.present(logoutAlert, animated: true, completion: nil)
        
        
        
    }
    
    @objc func uploadImage(_ sender: UIButton) {
        let userImagePicker = UIImagePickerController()
        userImagePicker.delegate = self
        userImagePicker.sourceType = .photoLibrary
        userImagePicker.mediaTypes = ["public.image","public.video"]
        self.present(userImagePicker,animated: true,completion: nil)
    }
    
    
    func downloadProfileImage(){
        let image = AuthManager.shared.profilePicture
        APICaller.shared.getImageReferece(name: image) {
            reference in
            self.userProfileImageReference = reference
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    
    func getFilesReferences() {
        APICaller.shared.getImagesReferences {
            result in
            guard let result = result else { return }
            for item in result.items{
                self.images.append(item)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
}


extension UploadPhotoViewController :UploadHeaderDelegate{
    func uploadPhoto() {
        let userImagePicker = UIImagePickerController()
        userImagePicker.delegate = self
        userImagePicker.sourceType = .photoLibrary
        userImagePicker.mediaTypes = ["public.image","public.video"]
        self.present(userImagePicker,animated: true)
    }
    
    func uploadProfilePhoto() {
        self.isProfilePicture = true
        self.uploadPhoto()
    }
}


extension UploadPhotoViewController : UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let optimizeImageData = userImage.jpegData(compressionQuality: 0.6){
            let name = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
            self.imageData = optimizeImageData
            self.imageName = name?.lastPathComponent
        }
        picker.dismiss(animated: true) {
            if let image = self.imageData {
                if self.isProfilePicture {
                    APICaller.shared.uploadProfileImage(imageData: image, imageName: self.imageName,completion: self.afterUploaded )
                } else {
                    APICaller.shared.uploadImage(imageData: image, imageName: self.imageName,completion: self.afterUploaded )
                }
            }
        }
    }
    
    
    func afterUploaded(reference:StorageReference){
            print(reference)
            self.images.append(reference)
            if self.isProfilePicture {
                self.userProfileImageReference = reference
                self.isProfilePicture = false
                
            }
            self.imageData = nil
            self.imageName = nil
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        
    }
    
}

extension UploadPhotoViewController  :UINavigationControllerDelegate {
}

extension UploadPhotoViewController  :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
        let image = cell?.bg.image
        let ref = self.images[indexPath.item]
        let vc = DetailViewController(image: image)
        vc.documentReference = ref
        vc.navigationItem.title = "Photo Detail"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
          case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath) as? HeaderCollectionReusableView
            else {
                fatalError("Invalid view type")
            }
            headerView.headerDelegate = self
            let placeholder = UIImage(named: "placeholder")
            headerView.userImageView.sd_setImage(with: self.userProfileImageReference, placeholderImage: placeholder)
            
            return headerView
          default:
            // 4
            assert(false, "Invalid element type")
          }
    }
    
    
}


extension UploadPhotoViewController  :UICollectionViewDelegateFlowLayout {
    // Calculo para cada celda segun el numero de items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let numberOfItemsPerRow:CGFloat = 3
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
           
            let totalSpacing = Int(flowLayout.sectionInset.left) + Int(flowLayout.sectionInset.right) + Int((numberOfItemsPerRow-1) * flowLayout.minimumInteritemSpacing)
            let width = (Int(collectionView.bounds.width) - totalSpacing)/Int(numberOfItemsPerRow)
            return CGSize(width: width, height: width)
            
    }
    // Padding de las celdas respecto al borde del collectionview
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 4, left: 8, bottom: 4, right: 8);
    }
    // Intelineado
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    //Espacio entre columnas
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.width, height: self.view.height/3)
    }
    
    
}

extension UploadPhotoViewController  :UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        let urlRef = self.images[indexPath.item]
        let placeholderImage = UIImage(named:"placeholder")
        cell.bg.sd_setImage(with: urlRef, placeholderImage:placeholderImage)
        return cell
    }
    
    
}
