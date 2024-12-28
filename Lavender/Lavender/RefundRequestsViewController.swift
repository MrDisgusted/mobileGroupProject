//
//  RefundRequestsViewController.swift
//  Lavender
//
//  Created by Carter Stone on 21/12/2024.
//

import UIKit
import FirebaseFirestore

class RefundRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var refundRequests: [RefundRequest] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchRefundRequests()
    }

    func fetchRefundRequests() {
        db.collection("refundRequests").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching refund requests: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            self.refundRequests = documents.compactMap { doc -> RefundRequest? in
                let data = doc.data()
                return RefundRequest(
                    id: data["id"] as? String ?? "",
                    customerName: data["customerName"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    productName: data["productName"] as? String ?? "",
                    category: data["category"] as? String ?? "",
                    imageUrl: data["imageUrl"] as? String ?? ""
                )
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refundRequests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefundRequestCell", for: indexPath) as! RefundRequestCell
        cell.configure(with: refundRequests[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRequest = refundRequests[indexPath.row]
        let storyboard = UIStoryboard(name: "AddProduct", bundle: nil)
        if let refundPageVC = storyboard.instantiateViewController(withIdentifier: "RefundPageViewController") as? RefundPageViewController {
            refundPageVC.refundRequest = selectedRequest
            navigationController?.pushViewController(refundPageVC, animated: true)
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
