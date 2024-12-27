//
//  OrdersListViewController.swift
//  Lavender
//
//  Created by Carter Stone on 27/12/2024.
//

import UIKit
import FirebaseFirestore
struct Order {
    let id: String
    let customerName: String
    let address: String
    let phoneNumber: String
    let imageUrl: String
    let orderDetails: String
    let status: String}

class OrdersListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    
    
    

    @IBOutlet weak var tableView: UITableView!
    
    
    let db = Firestore.firestore()
        var orders: [Order] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            tableView.delegate = self
            fetchOrders()
        }
    

    func fetchOrders() {
           db.collection("orders").getDocuments { snapshot, error in
               if let error = error {
                   print("Error fetching orders: \(error.localizedDescription)")
                   return
               }
               guard let documents = snapshot?.documents else { return }

               self.orders = documents.compactMap { doc -> Order? in
                   let data = doc.data()
                   guard
                       let id = data["id"] as? String,
                       let customerName = data["customerName"] as? String,
                       let address = data["address"] as? String,
                       let phoneNumber = data["phoneNumber"] as? String,
                       let imageUrl = data["imageUrl"] as? String,
                       let orderDetails = data["orderDetails"] as? String,
                       let status = data["status"] as? String
                   else {
                       return nil
                   }

                   return Order(
                       id: id,
                       customerName: customerName,
                       address: address,
                       phoneNumber: phoneNumber,
                       imageUrl: imageUrl,
                       orderDetails: orderDetails,
                       status: status
                   )
               }

               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           }
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return orders.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as? OrderTableViewCell else {
               fatalError("Could not dequeue OrderTableViewCell")
           }
           let order = orders[indexPath.row]
           cell.orderNameLabel.text = order.customerName
           cell.orderIdLabel.text = order.id
           cell.orderStatusLabel.text = order.status
           cell.orderStatusLabel.textColor = order.status.lowercased() == "processed" ? .green : .red
           if let url = URL(string: order.imageUrl) {
               URLSession.shared.dataTask(with: url) { data, _, _ in
                   if let data = data {
                       DispatchQueue.main.async {
                           cell.orderImageView.image = UIImage(data: data)
                       }
                   }
               }.resume()
           }
           return cell
       }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOrderDetails",
           let orderPageVC = segue.destination as? OrderPageViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            orderPageVC.order = orders[indexPath.row]
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
