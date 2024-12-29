import UIKit
import FirebaseFirestore

class ProductSearchTableViewController: UITableViewController {

    var selectedCategory: String?
    var productArray: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = " Results(0)"
        fetchProducts()
    }

    func fetchProducts() {
        guard let category = selectedCategory else {
            print("No category selected.")
            return
        }

        print("Fetching products for category: \(category)")

        let db = Firestore.firestore()
        db.collection("storeProducts")
            .whereField("category", isEqualTo: category.lowercased())
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching products: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No products found for category: \(category)")
                    return
                }

                print("Documents fetched: \(documents.count)")

                self.productArray = documents.compactMap { doc -> Product? in
                    let data = doc.data()
                    print("Document data: \(data)")

                    guard
                        let id = data["ID"] as? Int,
                        let name = data["name"] as? String,
                        let imageString = data["imageUrl"] as? String,
                        let description = data["description"] as? String,
                        let price = data["price"] as? Double
                    else {
                        print("Invalid product data for document: \(doc.documentID)")
                        return nil
                    }

                    let imageData = Data(imageString.utf8)

                    return Product(
                        ID: id,
                        name: name,
                        image: imageData,
                        category: self.categoryFromString(category) ?? .bodycare,
                        description: description,
                        price: price,
                        quantity: 0,
                        lavender: Ecobar(emission: 0, impact: 0, sustainability: 0, recyclability: 0, longjevity: 0),
                        isAvailable: true,
                        arrivalDay: 0
                    )
                }

                print("Products loaded into array: \(self.productArray.count)")

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.updateResultsLabel()
                }
            }
    }


    func updateResultsLabel() {
        self.title = " Results(\(productArray.count))"
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Product", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Product",
           let destinationVC = segue.destination as? ProductViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.product = productArray[indexPath.row]
        }
    }
}

