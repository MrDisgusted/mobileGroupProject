import UIKit

class CartTableViewCell: UITableViewCell {

    // UI Components
    let productImageView = UIImageView()
    let productNameLabel = UILabel()
    let quantityLabel = UILabel()
    let stepper = UIStepper()

    // Stepper Action Closure
    var stepperAction: ((Int) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Add UI components to the content view
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(stepper)

        // Configure UI components
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFit
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true

        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.font = UIFont.systemFont(ofSize: 14)

        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)

        // Add Constraints
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 50),
            productImageView.heightAnchor.constraint(equalToConstant: 50),

            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productNameLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -10),

            quantityLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            quantityLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),

            stepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stepper.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func setupCell(photo: UIImage?, name: String, quantity: Int, stepperAction: @escaping (Int) -> Void) {
        productImageView.image = photo
        productNameLabel.text = name
        quantityLabel.text = "Qty: \(quantity)"
        stepper.value = Double(quantity)

        self.stepperAction = stepperAction
    }

    @objc private func stepperValueChanged(_ sender: UIStepper) {
        let newQuantity = Int(sender.value)
        quantityLabel.text = "Qty: \(newQuantity)"
        stepperAction?(newQuantity)
    }
}

