//
//  Extensions.swift
//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 27/03/21.
//

import UIKit

// Extensiones para obtener las medidas de la pantalla y hacer subvistas basadas en medidas rectangulares
extension UIView{
    var width:CGFloat {
        return frame.size.width
    }
    
    var height:CGFloat {
        return frame.size.height
    }
    
    var  left:CGFloat {
        return frame.origin.x
    }
    
    var right:CGFloat {
        return left + width
    }
    
    var top : CGFloat{
        return frame.origin.y
    }
    
    var bottom: CGFloat{
        return top + height
    }
    
    // Animación de boton Revisar
    static func animateFlashButton(sender button: UIButton){
        UIView.animate(withDuration: 0.05, animations: {
            button.alpha = 0.1
        },
        completion: {
            done in
            UIView.animate(withDuration: 0.05) {
                button.alpha = 1
            }
        })
    }
    
}
