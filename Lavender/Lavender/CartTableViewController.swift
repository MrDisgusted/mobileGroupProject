import UIKit

class CartTableViewController: UITableViewController {

    @IBOutlet weak var totalPriceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartCell")

        updateTotalPrice()
    }

    // MARK: - TableView Data Source
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
                self.updateQuantity(for: product, quantity: newQuantity)
            }
        )
        return cell
    }

    private func updateQuantity(for product: Product, quantity: Int) {
        CartManager.shared.updateQuantity(for: product, quantity: quantity)
        tableView.reloadData()
        updateTotalPrice()
    }

    private func updateTotalPrice() {
        let totalPrice = CartManager.shared.calculateTotalPrice()
        totalPriceLabel.text = String(format: "Total: $%.2f", totalPrice)
    }
}

