//
//  LoginNavigationController.swift
//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 31/03/21.
//

import UIKit

class LoginNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc  = LoginViewController()
        
        vc.title = "Login"
        vc.navigationItem.largeTitleDisplayMode = .always
        self.navigationBar.prefersLargeTitles = true
        setViewControllers([vc], animated: false)
        
        

    }
    

}

