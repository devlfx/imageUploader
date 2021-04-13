//
//  UploadHeaderDelegate.swift
//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 06/04/21.
//

// Protocol que describe lo necesario para ser le delegado de la vista reutilizable
import Foundation

protocol UploadHeaderDelegate {
    func uploadPhoto() -> Void
    func uploadProfilePhoto() -> Void
}
