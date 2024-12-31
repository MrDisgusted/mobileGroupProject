//
//  OrderTableViewCell.swift
//  Lavender
//
//  Created by Carter Stone on 27/12/2024.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var orderImageView: UIImageView!
    
    
    @IBOutlet weak var orderNameLabel: UILabel!
    
    
    @IBOutlet weak var orderIdLabel: UILabel!
    
   
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Do any additional setup after loading the view.
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
