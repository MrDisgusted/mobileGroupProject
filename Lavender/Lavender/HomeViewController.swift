//
//  HomeViewController.swift
//  Lavender
//
//  Created by BP-36-201-07 on 11/12/2024.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recommendedTable: UITableView!
    var productArray:[Product] = [Product]()
    var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendedTable.delegate = self
        recommendedTable.dataSource = self
        
        //        if let loadedProducts = loadProducts() {
        //            Product = loadedProducts
        //        }
        
        //        tableViewSetup()
    }
    
    //    func tableViewSetup(){
    //        recommendedTable = UITableView(frame: self.view.bounds, style: .plain) as UITableView
    //        recommendedTable.register(UITableViewCell.self, forCellReuseIdentifier: "ProductCell")
    //        self.view.addSubview(recommendedTable)
    
    //for Ebrahim to make the Add product feature for the store owner
    //let addButton = UIBarButtonItem(title: "Add Product", style: .plain, target: self, action: #selector(addProduct))
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedCell") as! HomeTableViewCell
        return cell
    }
}

