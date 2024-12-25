//
//  HomeTableViewCell.swift
//  Lavender
//
//  Created by BP-36-201-07 on 11/12/2024.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var ProductImage: UIImageView!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var ProductDescription: UILabel!
    @IBOutlet weak var ProductPrice: UIButton!

    @IBAction func buttonPurchase(_ sender: Any) {
        
    }
    
    func setupCell(photo: UIImage, name: String, price: Double, description: String) {
        ProductImage.image = photo
        ProductName.text = name
        ProductDescription.text = description
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
