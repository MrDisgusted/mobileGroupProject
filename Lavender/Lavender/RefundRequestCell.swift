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
}



