//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 27/03/21.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc  = UploadPhotoViewController()
        
        vc.title = "Upload Photo"
        vc.navigationItem.largeTitleDisplayMode = .always
        self.navigationBar.prefersLargeTitles = true
        setViewControllers([vc], animated: false)
    }
}
