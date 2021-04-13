//
//  LoginViewController.swift
//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 27/03/21.
//

import UIKit

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        // PAra pode rusar constraints manuales
        textField.translatesAutoresizingMaskIntoConstraints = false
        // Asignar tamaño de fuente
        textField.font = UIFont.systemFont(ofSize: 16)
        // Que no ponga mayúscula en el email
        textField.autocapitalizationType = .none
        // Que se vea gordito y bonito
        textField.layer.cornerRadius = 20.0
        // Que tenga un borde visible ccon ancho de un punto
        textField.layer.borderWidth = 1.0
        // Color del borde
        textField.layer.borderColor = UIColor.systemGray.cgColor
        // Sin Autocorrector
        textField.autocorrectionType = UITextAutocorrectionType.no
        // Asignar teclado normal
        textField.keyboardType = UIKeyboardType.default
        // Que sucede al darle enter
        textField.returnKeyType = UIReturnKeyType.done
        // Mostrar boton para vaciar el campo
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        // Centrar el contenido verticalmente
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
        // Do any additional setup after loading the view.
        
        self.title = "Login"
        
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(emailField)
        self.view.addSubview(loginButton)
        self.view.addSubview(signInButton)
        self.view.addSubview(password)
        
        self.addConstraints()
        
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchDown)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchDown)
    }
  
    override func viewDidDisappear(_ animated: Bool) {
        print("Desaparecio")
    }
    
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        // Dimensiones
        constraints.append( emailField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8) )
        constraints.append( emailField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier:0.09) )
        //POsiscion
        constraints.append( emailField.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor) )
        constraints.append( emailField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 70) )
        
        constraints.append( password.widthAnchor.constraint(equalTo: emailField.widthAnchor) )
        constraints.append( password.heightAnchor.constraint(equalTo: emailField.heightAnchor) )
        
        constraints.append( password.leadingAnchor.constraint(equalTo: emailField.leadingAnchor) )
        constraints.append( password.trailingAnchor.constraint(equalTo: emailField.trailingAnchor) )
        constraints.append( password.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 8) )
        
        //dimensiones del boton
        constraints.append( loginButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier:0.40) )
        constraints.append( loginButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier:0.09) )
        //Posicion del boton
        constraints.append( loginButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 32) )
        constraints.append( loginButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -120) )
        
        constraints.append( signInButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier:0.40) )
        constraints.append( signInButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier:0.09) )
        constraints.append( signInButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -32) )
        constraints.append( signInButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -120) )
        
        // Activamos constraints
        NSLayoutConstraint.activate(constraints)
    }
    

    @objc func didTapLogin(sender: UIButton) {

        UIView.animateFlashButton(sender: sender)
        guard let email = self.emailField.text else { return }
        guard let password = self.password.text else { return }
        
        AuthManager.shared.login(withEmail: email, password: password) {
            [weak self] user in
            let mainApp = MainNavigationController()
            mainApp.modalPresentationStyle = .fullScreen
            self?.present(mainApp, animated: true, completion: nil)
        }
    }
    
    @objc func didTapSignIn(sender: UIButton) {
        UIView.animateFlashButton(sender: sender)
        let vc = SignInViewController()
        vc.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   


}

