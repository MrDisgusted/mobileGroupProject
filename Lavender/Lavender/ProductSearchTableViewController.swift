import UIKit
import FirebaseFirestore

class ProductSearchTableViewController: UITableViewController {

    var selectedCategory: String?
    var allProducts: [Product] = []
    var filteredProducts: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedCategory

        fetchAllProducts()
    }

    func categoryFromString(_ string: String) -> Category? {
        switch string.lowercased() {
        case "bodycare": return .bodycare
        case "cleaning": return .cleaning
        case "stationary": return .stationary
        case "gardening": return .gardening
        case "supplements": return .supplements
        case "accessories": return .accessories
        case "food": return .food
        case "hygiene": return .hygiene
        case "electronics": return .electronics
        default: return nil
        }
    }

    func fetchAllProducts() {
        let db = Firestore.firestore()
        db.collection("storeProducts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching products: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            self.allProducts = documents.compactMap { doc -> Product? in
                let data = doc.data()
                
                guard
                    let id = data["ID"] as? Int,
                    let name = data["name"] as? String,
                    let imageString = data["imageUrl"] as? String,
                    let imageUrl = URL(string: imageString),
                    let imageData = try? Data(contentsOf: imageUrl),
                    let categoryString = data["category"] as? String,
                    let category = self.categoryFromString(categoryString),
                    let description = data["description"] as? String,
                    let price = data["price"] as? Double,
                    let quantity = data["quantity"] as? Int,
                    let isAvailable = data["isAvailable"] as? Bool,
                    let arrivalDay = data["arrivalDay"] as? Int
                else {
                    return nil
                }

                let lavender = Ecobar(emission: 0, impact: 0, sustainability: 0, recyclability: 0, longjevity: 0)

                return Product(
                    ID: id,
                    name: name,
                    image: imageData,
                    category: category,
                    description: description,
                    price: price,
                    quantity: quantity,
                    lavender: lavender,
                    isAvailable: isAvailable,
                    arrivalDay: arrivalDay
                )
            }

            self.filterProducts()
        }
    }

    func filterProducts() {
        guard let category = selectedCategory else { return }

        if category == "All" {
            filteredProducts = allProducts
        } else {
            filteredProducts = allProducts.filter { product in
                product.category.toString == category
            }
        }

        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = filteredProducts[indexPath.row]

        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = "$\(product.price)"
        return cell
    }
}

