//
//  SignInViewController.swift
//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 31/03/21.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    var ref : DocumentReference!
    var getRef : Firestore!
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemPink.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 20.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    lazy var password: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 20.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign In"
        self.getRef = Firestore.firestore()
        view.backgroundColor = .systemBackground
        view.addSubview(emailField)
        view.addSubview(signInButton)
        view.addSubview(password)
        
        self.addConstraints()
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchDown)
        // Do any additional setup after loading the view.
    }
    
    func addConstraints(){
        var constraints = [NSLayoutConstraint]()
        
        constraints.append( emailField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8) )
        constraints.append( emailField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier:0.09) )
        constraints.append( emailField.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor) )
        constraints.append( emailField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 70) )
        
        constraints.append( password.widthAnchor.constraint(equalTo: emailField.widthAnchor) )
        constraints.append( password.heightAnchor.constraint(equalTo: emailField.heightAnchor) )
        constraints.append( password.leadingAnchor.constraint(equalTo: emailField.leadingAnchor) )
        constraints.append( password.trailingAnchor.constraint(equalTo: emailField.trailingAnchor) )
        constraints.append( password.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 8) )

        constraints.append( signInButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier:0.50) )
        constraints.append( signInButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier:0.09) )
        constraints.append( signInButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor) )
        constraints.append( signInButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -120) )
        

        NSLayoutConstraint.activate(constraints)
    }

    
    @objc func didTapSignIn(sender: UIButton) {
        UIView.animateFlashButton(sender: sender)
        guard let email = self.emailField.text else { return }
        guard let password = self.password.text else { return }
        AuthManager.shared.signIn(withEmail: email, password: password) {
            [weak self] in
            let vc = MainNavigationController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
            print("datos guardados")
        }
        
    }
    
    
}
