//
//  RefundRequestsViewController.swift
//  Lavender
//
//  Created by Carter Stone on 21/12/2024.
//

import UIKit

extension UIImageView {
    func loadImage(from url: String) {
        guard let imageUrl = URL(string: url) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}


class RefundRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refundRequests = [
        ["imageUrl": "https://res.cloudinary.com/dya8ndfhj/image/upload/v1734481228/Seedball_Wildlife_Collection_kxcwor.jpg",
         "title": "Seedball Wildlife Collection",
         "category": "Gardening",
         "refundID": "#8932"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refundRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefundRequestCell", for: indexPath) as! RefundRequestCell
        
        let refund = refundRequests[indexPath.row]
        cell.titleLabel.text = refund["title"]
        cell.categoryLabel.text = refund["category"]
        cell.refundIDLabel.text = "Refund \(refund["refundID"] ?? "")"
        cell.refundImageView.loadImage(from: refund["imageUrl"] ?? "")

        return cell
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
