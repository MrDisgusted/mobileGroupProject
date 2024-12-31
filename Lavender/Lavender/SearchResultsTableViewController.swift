import UIKit
import FirebaseFirestore

class SearchResultsTableViewController: UITableViewController {

    var searchQuery: String?
    var searchResults: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSearchResults()
    }

    func fetchSearchResults() {
        guard let query = searchQuery, !query.isEmpty else {
            print("Search query is empty.")
            return
        }

        let db = Firestore.firestore()
        db.collection("storeProducts")
            .whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching search results: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No products found for query: \(query)")
                    return
                }

                self.searchResults = documents.compactMap { doc -> Product? in
                    let data = doc.data()
                    guard
                        let id = data["ID"] as? Int,
                        let name = data["name"] as? String,
                        let imageUrl = data["imageUrl"] as? String,
                        let description = data["description"] as? String,
                        let price = data["price"] as? Double
                    else { return nil }

                    return Product(
                        ID: id,
                        name: name,
                        image: imageUrl.data(using: .utf8) ?? Data(),
                        category: .bodycare,
                        description: description,
                        price: price,
                        quantity: 0,
                        lavender: Ecobar(emission: 0, impact: 0, sustainability: 0, recyclability: 0, longjevity: 0),
                        isAvailable: true,
                        arrivalDay: 0
                    )
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultTableViewCell
        let product = searchResults[indexPath.row]

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
            description: product.description,
            product: product
        )
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Product2", sender: searchResults[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Product2",
           let destinationVC = segue.destination as? ProductViewController,
           let product = sender as? Product {
            destinationVC.product = product
        }
    }
}

