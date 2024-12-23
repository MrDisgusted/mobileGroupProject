import UIKit

class ProductListViewController: UIViewController, AddProductDelegate {

    
    @IBOutlet weak var tableView: UITableView!

  
//    var sampleProducts = [
//        Product(imageUrl: "https://res.cloudinary.com/dya8ndfhj/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1734461472/samples/uy2j8cyjgfgfl2uzmb2t.jpg",
//                title: "Loofah washing up pads", category: "Body Care", price: "$4.99"),
//        Product(imageUrl: "https://res.cloudinary.com/dya8ndfhj/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1734481228/Seedball_Wildlife_Collection_kxcwor.jpg",
//                title: "Seedball Wildlife Collection", category: "Gardening", price: "$8.99"),
//        Product(imageUrl: "https://res.cloudinary.com/dya8ndfhj/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1734481228/Paper_Ballpoint_Pens_24_lzt4si.jpg",
//                title: "Paper Ballpoint Pens - 24 pack", category: "Stationary", price: "$12.99"),
//        Product(imageUrl: "https://res.cloudinary.com/dya8ndfhj/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1734481228/Microsoft_Recycled_Mouse_gfty3w.avif",
//                title: "Microsoft Recycled Mouse", category: "Electronics", price: "$89.99")
//    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 55, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.allowsMultipleSelectionDuringEditing = true
    }

    func didAddProduct(_ product: Product) {
        //sampleProducts.append(product)
        tableView.reloadData()
    }

    
    @IBAction func addProductButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddProduct", bundle: nil)
        if let addProductVC = storyboard.instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController {
            addProductVC.delegate = self
            present(addProductVC, animated: true)
        }
    }

    @IBAction func selectButtonTapped(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        (sender as? UIButton)?.setTitle(tableView.isEditing ? "Cancel" : "Select", for: .normal)
    }
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 //sampleProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        //let product = sampleProducts[indexPath.row]
        
        //cell.titleLabel.text = product.title
        //cell.categoryLabel.text = product.category
        //cell.priceLabel.text = product.price
        
//        if let url = URL(string: product.imageUrl) {
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data, error == nil {
//                    DispatchQueue.main.async {
//                        cell.productImageView.image = UIImage(data: data)
//                    }
//                }
//            }.resume()
//        } else {
//            cell.productImageView.image = UIImage(named: "placeholder")
//        }

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            sampleProducts.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
    }
}
