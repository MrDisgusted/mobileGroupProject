//
//  MyStoreViewController.swift
//  Lavender
//
//  Created by Carter Stone on 29/12/2024.
//

import UIKit
import FirebaseFirestore

class MyStoreViewController: UIViewController {
    @IBOutlet weak var storeNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStoreDetails()
    }
    
    
    
    @IBAction func myShopButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddProduct", bundle: nil)
            let myShopVC = storyboard.instantiateViewController(withIdentifier: "MyProductsPage")
            myShopVC.modalPresentationStyle = .fullScreen
            present(myShopVC, animated: true, completion: nil)
    }
    
    func fetchStoreDetails() {
        guard let loggedInStoreName = UserDefaults.standard.string(forKey: "loggedInStoreName") else {
            showAlert(title: "Error", message: "No matching store found. (Logged-in store name missing)")
            return
        }

        let db = Firestore.firestore()
        let storesRef = db.collection("stores")

        storesRef.whereField("store name", isEqualTo: loggedInStoreName).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Error", message: "Failed to fetch store details: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents, !documents.isEmpty else {
                self.showAlert(title: "Error", message: "No matching store found. (Store name not found in database)")
                return
            }

            if let storeData = documents.first?.data(),
               let storeName = storeData["store name"] as? String {
                self.storeNameLabel.text = storeName
            } else {
                self.showAlert(title: "Error", message: "Failed to load store details.")
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "loggedInStoreName")
               UserDefaults.standard.removeObject(forKey: "loggedInStoreID")
               UserDefaults.standard.synchronize()
               
               let storyboard = UIStoryboard(name: "AUTH", bundle: nil)
               let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
               loginVC.modalPresentationStyle = .fullScreen
               present(loginVC, animated: true, completion: nil)
        
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
