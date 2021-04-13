//
//  DetailViewController.swift
//  ImageUploader
//
//  Created by Luis Abraham Ortega Gonzalez on 27/03/21.
//

import UIKit
import Firebase
import FirebaseUI

class DetailViewController: UIViewController {
    
    var details = [String]()

    
    var documentReference : StorageReference?
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "placeholder")
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    init(image: UIImage?){
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(table)
        self.view.addSubview(imageView)
        
        self.table.delegate = self
        self.table.dataSource = self
        self.getMetadata()
        self.addConstraints()
    }
    
    func getMetadata() {
        if let image = self.documentReference {
            APICaller.shared.getDocumentMetadata(fromReference: image) {
                results in
                self.details.append("Nombre - \(results.name ?? "")")
                if let date = results.timeCreated {
                    let frmtDate = DateFormatter()
                    frmtDate.dateStyle = .short
                    self.details.append("Fecha de creacion - \(frmtDate.string(from: date))" )
                }
                self.details.append("hash - \(results.md5Hash ?? "")")
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        }
    }
    
    
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append( imageView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6) )
        constraints.append( imageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6) )
        constraints.append( imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20) )
        constraints.append( imageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor) )
        
        constraints.append( table.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor) )
        constraints.append( table.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.50 ) )
        constraints.append( table.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append( table.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor) )
        
        NSLayoutConstraint.activate(constraints)
    }
    

}


extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = self.details[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        print("Detalles \(self.details)")
        return cell
    }
    
    
}

