import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!

    var product: Product?
    private var stepperAction: ((Int) -> Void)?

    func setupCell(photo: UIImage?, name: String, quantity: Int, stepperAction: @escaping (Int) -> Void) {
        productImageView.image = photo
        productNameLabel.text = name
        productNameLabel.accessibilityLabel = "Product name: \(name)"
        quantityLabel.text = "Qty: \(quantity)"
        quantityLabel.accessibilityLabel = "Quantity: \(quantity)"
        stepper.value = Double(quantity) // Sync the stepper value with the quantity

        self.stepperAction = stepperAction
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }

    @objc private func stepperValueChanged(_ sender: UIStepper) {
        let newQuantity = Int(sender.value)
        quantityLabel.text = "Qty: \(newQuantity)"
        stepperAction?(newQuantity) // Notify the action handler
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productNameLabel.text = ""
        quantityLabel.text = ""
        stepper.value = 0
    }
}

