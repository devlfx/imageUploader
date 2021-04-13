//
//  APICaller.swift
//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 08/04/21.
//
// Singleton que maneja las llamadas a Firestore y storage para obtener imagenes e información del usuario
// Mover a un repositorio (?)

import Foundation
import Firebase

class APICaller {
    static var shared = APICaller()
    let storage = Storage.storage()
    private var db: Firestore!
    
    private init(){
        self.db = Firestore.firestore()
    }
    
    
    func getImageReferece(name:String?, completion: ((StorageReference) -> Void)? ){
        guard let user = Auth.auth().currentUser else { return }
        guard let name = name else { return }
        
        let storageRef = storage.reference()
        let fileRef = storageRef.child("photos/profile/\(user.uid)/\(name)")
        completion?(fileRef)
    }
    
    func uploadProfileImage(imageData: Data, imageName: String?, completion: ((StorageReference) -> Void)? ) {
        guard let user = Auth.auth().currentUser else { return }
        guard let name = imageName else { return }
        self.uploadImage(imageData: imageData, imageName: imageName) {
            reference in
            let data:[String : Any] = ["profilePicture":imageName]
            AuthManager.shared.updateUserInfo(userUID: user.uid, data: data)
            completion?(reference)
        }
    }
    
    
    func uploadImage(imageData: Data, imageName: String?, completion: ((StorageReference) -> Void)? ) {
        
        guard let user = Auth.auth().currentUser else { return }
        guard let imageName = imageName else { return }
        
        let storageRef = self.storage.reference()
        let imageRef = storageRef.child("photos").child("profile").child(user.uid).child(imageName)
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: uploadMetaData){
            (metadata,error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion?(imageRef)
            }
        }
    }
    
    
    func getImagesReferences( completion: ((StorageListResult?) -> Void)? ) {
        guard let user = Auth.auth().currentUser else { return }
        let storageRef = storage.reference().child("photos/profile/\(user.uid)/")
        storageRef.listAll { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            completion?(result)
        }
    }
    
    
    func getDocumentMetadata(fromReference reference: StorageReference, completion: ((StorageMetadata) -> Void)? ){
        reference.getMetadata {
            metaData,error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let metaData = metaData else { return }
            
            print(metaData)
            completion?(metaData)
        }
    }
    
    func getDocumentMetadata( fromPath path: String ){
        guard let user = Auth.auth().currentUser else { return }
        let storageRef = storage.reference().child("photos/profile/\(user.uid)/")
        
    }
    
    
}
