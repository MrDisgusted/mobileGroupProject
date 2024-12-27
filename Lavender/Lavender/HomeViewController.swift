//
//  HomeViewController.swift
//  Lavender
//
//  Created by BP-36-201-07 on 11/12/2024.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedCell") as! HomeTableViewCell
        return cell
    }
    
    
    @IBOutlet weak var recommendedTable: UITableView!
    var productArray: [Product] = []
    var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendedTable.delegate = self
        recommendedTable.dataSource = self
        
    }
    
    func fetchProduct(byID productID: Int, completion: @escaping (Product?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("storeProducts").whereField("ID", isEqualTo: productID).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching product: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let document = querySnapshot?.documents.first else {
                print("Product not found!")
                completion(nil)
                return
            }
            
            
        }
    }
    
}
