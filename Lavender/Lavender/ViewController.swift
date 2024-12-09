//
//  ViewController.swift
//  Lavender
//
//  Created by BP-36-201-07 on 04/12/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var RecommendedTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        RecommendedTable.delegate = self
        RecommendedTable.dataSource = self
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: <#T##IndexPath#>)
        
        return cell
    }
}


