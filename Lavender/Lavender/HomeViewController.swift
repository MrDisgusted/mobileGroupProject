//
//  HomeViewController.swift
//  Lavender
//
//  Created by BP-36-201-07 on 11/12/2024.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TableView: UITableView!
    var productArray = [product]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedCell") as! HomeTableViewCell
        let data = productArray[indexPath.row]
        
        return cell
    }

}

enum Category{
    case bodycare
    case stationary
    case electronics
    case gardening
    case clothing
    case supplements
    case accessories
    case food
}

struct product {
    let ID : Int
    let name : String
    let image : UIImage
    let category : Category
    let description : String
    let price : Double
    let isAvailable : Bool
    let arrivalDay : Int
    
    
}
