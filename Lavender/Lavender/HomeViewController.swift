//
//  HomeViewController.swift
//  Lavender
//
//  Created by BP-36-201-07 on 11/12/2024.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TableView: UITableView!
    
    var productArray: [Product] = []
    var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
        
//        if let loadedProducts = loadProducts() {
//            Product = loadedProducts
//        }
        
        tableViewSetup()
    }
    
    func tableViewSetup(){
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductCell")
        self.view.addSubview(tableView)
        
        //for Ebrahim to make the Add product feature for the store owner
        //let addButton = UIBarButtonItem(title: "Add Product", style: .plain, target: self, action: #selector(addProduct))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedCell") as! HomeTableViewCell

        
        return cell
    }

}
