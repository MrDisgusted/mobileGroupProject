import UIKit

class ProductTableViewCell: UITableViewCell {

    
    let productImageView = UIImageView()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    let priceLabel = UILabel()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }


   
    private func setupViews() {
        contentView.backgroundColor = .black
        titleLabel.textColor = .white
        categoryLabel.textColor = .lightGray
        priceLabel.textColor = .systemBlue

        productImageView.contentMode = .scaleAspectFit
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(productImageView)

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        categoryLabel.font = UIFont.systemFont(ofSize: 12)
        categoryLabel.textColor = .lightGray
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)

        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = .systemBlue
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
    }


    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 60),
            productImageView.heightAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        ])

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: priceLabel.leftAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        ])

        NSLayoutConstraint.activate([
            categoryLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor)
        ])
    }
}
