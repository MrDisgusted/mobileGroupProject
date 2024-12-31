//
//  RefundPageViewController.swift
//  Lavender
//
//  Created by Carter Stone on 22/12/2024.
//

import UIKit
import FirebaseFirestore

class RefundPageViewController: UIViewController {
    @IBOutlet weak var refundIDLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!

    var refundRequest: RefundRequest?
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        displayRefundDetails()
    }

    func displayRefundDetails() {
        guard let refundRequest = refundRequest else { return }
        refundIDLabel.text = "Refund #\(refundRequest.id)"
        customerNameLabel.text = refundRequest.customerName
        descriptionTextView.text = refundRequest.description
    }

    @IBAction func approveButtonTapped(_ sender: UIButton) {
        handleRefundAction(approved: true)
    }

    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        handleRefundAction(approved: false)
    }

    func handleRefundAction(approved: Bool) {
        guard let refundID = refundRequest?.id else { return }
        db.collection("refundRequests").whereField("id", isEqualTo: refundID).getDocuments { snapshot, error in
            if let error = error {
                print("Error processing refund request: \(error.localizedDescription)")
                return
            }

            guard let document = snapshot?.documents.first else { return }
            document.reference.delete { error in
                if let error = error {
                    print("Error deleting refund request: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        let status = approved ? "approved" : "rejected"
                        let alert = UIAlertController(title: "Success", message: "Refund request has been \(status).", preferredStyle: .alert)
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
