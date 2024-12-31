//
//  OrderPageViewController.swift
//  Lavender
//
//  Created by Carter Stone on 27/12/2024.
//

import UIKit
import FirebaseFirestore

class OrderPageViewController: UIViewController {

    
    @IBOutlet weak var orderIdLabel: UILabel!
    
    
    @IBOutlet weak var customerNameLabel: UILabel!
    
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
   
    @IBOutlet weak var orderDetailsLabel: UILabel!
    
    
    @IBOutlet weak var processOrderButton: UIButton!
    
    
    var order: Order?
        let db = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayOrderDetails()
    }

    func displayOrderDetails() {
        guard let order = order else { return }
        orderIdLabel.text = order.id
        customerNameLabel.text = order.customerName
        phoneNumberLabel.text = order.phoneNumber
        addressLabel.text = order.address
        orderDetailsLabel.text = order.orderDetails
        processOrderButton.isEnabled = order.status.lowercased() != "processed"
        processOrderButton.backgroundColor = order.status.lowercased() == "processed" ? .lightGray : .systemBlue
    }

    
    
    @IBAction func processOrderButtonTapped(_ sender: Any) {
        guard let orderId = order?.id else { return }
               db.collection("orders").whereField("id", isEqualTo: orderId).getDocuments { snapshot, error in
                   if error != nil {
                       return
                   }
                   guard let document = snapshot?.documents.first else { return }
                   document.reference.updateData(["status": "processed"]) { error in
                       if error == nil {
                           DispatchQueue.main.async {
                               let alert = UIAlertController(title: "Success", message: "Order has been processed.", preferredStyle: .alert)
                               alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                                   self.navigationController?.popViewController(animated: true)
                               })
                               self.present(alert, animated: true)
                           }
                       }
                   }
               }
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
