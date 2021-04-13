//
//  AuthManager.swift
//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 10/04/21.
//
// Singleton que maneja los datos del usuario. Ya existe el auth pro porcionado por firebase pero asī guardamos los datos del usuario

import Foundation
import Firebase

class AuthManager {
    static var shared = AuthManager()
    
    private var db: Firestore!
    
    var isSignedIn:Bool{
        return Auth.auth().currentUser != nil
    }
    
    // Cache usado para guardar los datos del usuario. En donde se almacenan las preferencias segun la documentación
    // Preguntar si es correcto realizar esto.
    var email:String? {
        return UserDefaults.standard.string(forKey: "email")
    }
    
    var profilePicture:String? {
        return UserDefaults.standard.string(forKey:"profilePicture")
    }
    
    private init() {
        self.db = Firestore.firestore()
    }
    
    // Autenticarse
    public func login(withEmail email: String, password: String, completion: ((User) -> Void)? ) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print("error \(error?.localizedDescription)")
                return
            }
            guard let user = authResult?.user else { return }
            self.getUserInfo(userUID: user.uid)
            completion?(user)
            
        }
    }
    
    // Obtener datos del usuario de la BD
    public func getUserInfo(userUID: String) {
        let document = db.collection("users").document(userUID)
        document.getDocument {
            document, error in
            guard let document = document, document.exists else {
                print(error?.localizedDescription)
                return
            }
            print("user \(document.data())")
            self.cacheData(user: document.data())
        }
        
    }
    
    // Almacenar la información del usuario en cache
    public func cacheData(user: [String : Any]?) {
        guard let user = user else { return }
        UserDefaults.standard.set(user["email"] ?? "", forKey: "email")
        UserDefaults.standard.set(user["profilePicture"] ?? "", forKey: "profilePicture")
    }
    
    
    public func updateUserInfo(userUID: String, data: [String : Any]?){
        guard let data = data else { return }
        let document = db.collection("users").document(userUID)
        document.updateData(data) {
            error in
            if let error = error {
                    print("Error updating document: \(error)")
                } else {
                        data.forEach({
                            (key: String, value: Any) in
                            UserDefaults.standard.set(value, forKey: key)
                        })
                   
                }
        }
    }
    
    // To do: Limpiar el cache
    public func logout(completion: (() -> Void) ) {
        do {
            try Auth.auth().signOut()
            completion()
        }
        catch {
            print("logged out")
        }
    }
    
    
    public func signIn(withEmail email: String, password: String, completion: (()-> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            if error != nil {
                print("error \(error?.localizedDescription)")
                return
            }
            guard let user = authResult?.user else { return }
            var data : [String:Any] = ["email" : email,"profilePicture":""]
            self.createUser(userUID: user.uid, data: data) {
                completion?()
            }
        }
    }
    
    public func createUser(userUID: String, data: [String : Any]?, completion: (()-> Void)? ) {
        guard let data = data else { return }
        self.db.collection("users").document(userUID).setData(data,completion: {
            (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                    return
                } else {
                    completion?()
                }
                
        })
    }
    
    
}
