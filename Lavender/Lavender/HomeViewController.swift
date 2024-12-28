//
//  HomeViewController.swift
//  Lavender
//
//  Created by BP-36-201-07 on 11/12/2024.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recommendedTable: UITableView!
    var productArray: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendedTable.delegate = self
        recommendedTable.dataSource = self
        
        fetchRecommendedProducts()
    }

    func fetchRecommendedProducts() {
        let db = Firestore.firestore()
        
        db.collection("storeProducts").limit(to: 5).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error loading products: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No products found!")
                return
            }
            
            self.productArray = documents.compactMap { doc -> Product? in
                let data = doc.data()
                
                guard
                    let id = data["ID"] as? Int,
                    let name = data["name"] as? String,
                    let imageUrl = data["imageUrl"] as? String,
                    let categoryString = data["category"] as? String,
                    let description = data["description"] as? String,
                    let price = data["price"] as? Double,
                    let quantity = data["quantity"] as? Int,
                    let isAvailable = data["isAvailable"] as? Bool,
                    let arrivalDay = data["arrivalDay"] as? Int
                else {
                    return nil
                }

                let category: Category
                switch categoryString.lowercased() {
                case "bodycare": category = .bodycare
                case "cleaning": category = .cleaning
                case "stationary": category = .stationary
                case "gardening": category = .gardening
                case "supplements": category = .supplements
                case "accessories": category = .accessories
                case "food": category = .food
                case "hygiene": category = .hygiene
                default: category = .accessories
                }

                return Product(
                    ID: id,
                    name: name,
                    image: imageUrl.data(using: .utf8) ?? Data(),
                    category: category,
                    description: description,
                    price: price,
                    quantity: quantity,
                    lavender: Ecobar(emission: 0, impact: 0, sustainability: 0, recyclability: 0, longjevity: 0),
                    isAvailable: isAvailable,
                    arrivalDay: arrivalDay
                )
            }
            
            DispatchQueue.main.async {
                self.recommendedTable.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedCell", for: indexPath) as! HomeTableViewCell
        let product = productArray[indexPath.row]

        let image: UIImage? = {
            if let imageUrl = String(data: product.image, encoding: .utf8),
               let url = URL(string: imageUrl),
               let data = try? Data(contentsOf: url) {
                return UIImage(data: data)
            }
            return UIImage(named: "placeholder")
        }()

        cell.setupCell(
            photo: image,
            name: product.name,
            price: product.price,
            description: product.description
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Product", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Product",
           let destinationVC = segue.destination as? ProductViewController,
           let indexPath = recommendedTable.indexPathForSelectedRow {
            destinationVC.product = productArray[indexPath.row]
        }
    }
}
