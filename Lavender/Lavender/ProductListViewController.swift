import FirebaseFirestore
import UIKit

class ProductListViewController: UIViewController, AddProductDelegate {
    func didAddProduct(_ product: [String : Any]) {
        
    }
    
    
    
    
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        if let button = sender as? UIButton {
                tableView.setEditing(!tableView.isEditing, animated: true)
                button.setTitle(tableView.isEditing ? "Done" : "Select", for: .normal)
            }
    }
    

    @IBOutlet weak var tableView: UITableView!
    var products: [Product] = []
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 85
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        fetchProducts()
    }

    func didAddProduct(_ product: Product) {
        self.products.append(product)
        self.saveProductToFirebase(product)
        self.tableView.reloadData()
    }

    @IBAction func addProductButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddProduct", bundle: nil)
        if let addProductVC = storyboard.instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController {
            addProductVC.delegate = self
            present(addProductVC, animated: true)
        }
    }

    func fetchProducts() {
        db.collection("storeProducts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching products: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self.products = documents.compactMap { doc -> Product? in
                let data = doc.data()
                guard
                    let id = data["ID"] as? Int,
                    let name = data["name"] as? String,
                    let categoryString = data["category"] as? String,
                    let description = data["description"] as? String,
                    let price = data["price"] as? Double,
                    let quantity = data["quantity"] as? Int,
                    let isAvailable = data["isAvailable"] as? Bool,
                    let arrivalDay = data["arrivalDay"] as? Int,
                    let imageUrl = data["imageUrl"] as? String
                else { return nil }

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
                self.tableView.reloadData()
            }
        }
    }

    func saveProductToFirebase(_ product: Product) {
        let productData: [String: Any] = [
            "ID": product.ID,
            "name": product.name,
            "category": "\(product.category)",
            "description": product.description,
            "price": product.price,
            "quantity": product.quantity,
            "isAvailable": product.isAvailable,
            "arrivalDay": product.arrivalDay,
            "imageUrl": String(data: product.image, encoding: .utf8) ?? ""
        ]
        db.collection("storeProducts").document("\(product.ID)").setData(productData) { error in
            if let error = error {
                print("Error saving product: \(error.localizedDescription)")
            } else {
                print("Product saved successfully.")
            }
        }
    }
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        let product = products[indexPath.row]
        cell.titleLabel.text = product.name
        cell.categoryLabel.text = "\(product.category)"
        cell.priceLabel.text = "$\(product.price)"
        
        if let url = URL(string: String(data: product.image, encoding: .utf8) ?? "") {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.productImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            cell.productImageView.image = UIImage(named: "placeholder")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let productToDelete = products[indexPath.row]
            products.remove(at: indexPath.row)
            deleteProductFromFirebase(product: productToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func deleteProductFromFirebase(product: Product) {
        db.collection("storeProducts").whereField("ID", isEqualTo: product.ID).getDocuments { snapshot, error in
            if let documents = snapshot?.documents {
                documents.forEach { document in
                    document.reference.delete { error in
                        if let error = error {
                            print("Error deleting product: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }

}
