import UIKit

class CartTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the custom cell
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartCell")

        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.cartItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        let product = CartManager.shared.cartItems[indexPath.row]
        let quantity = CartManager.shared.quantities[product.ID, default: 0]

        cell.setupCell(
            photo: UIImage(data: product.image),
            name: product.name,
            quantity: quantity,
            stepperAction: { [weak self] newQuantity in
                guard let self = self else { return }
                CartManager.shared.updateQuantity(for: product, quantity: newQuantity)
                self.tableView.reloadData()
            }
        )
        return cell
    }
}

