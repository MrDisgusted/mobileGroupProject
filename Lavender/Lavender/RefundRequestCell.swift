//
//  RefundRequestCell.swift
//  Lavender
//
//  Created by Carter Stone on 21/12/2024.
//


import UIKit

class RefundRequestCell: UITableViewCell {
    @IBOutlet weak var refundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var refundIDLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!

    func configure(with refundRequest: RefundRequest) {
        titleLabel.text = refundRequest.productName
        categoryLabel.text = refundRequest.category
        refundIDLabel.text = "Refund #\(refundRequest.id)"
        
        if let url = URL(string: refundRequest.imageUrl) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.refundImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            refundImageView.image = UIImage(named: "placeholder")
        }
        
    }
    private func setupConstraints() {
        refundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        refundIDLabel.translatesAutoresizingMaskIntoConstraints = false
        detailButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            refundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            refundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            refundImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            refundImageView.widthAnchor.constraint(equalToConstant: 80),
            refundImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.leadingAnchor.constraint(equalTo: refundImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),

            refundIDLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            refundIDLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            refundIDLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            refundIDLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),

            detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            detailButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            detailButton.heightAnchor.constraint(equalToConstant: 30),
            detailButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

}



