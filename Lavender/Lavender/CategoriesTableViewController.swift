import UIKit

class CategoriesTableViewController: UITableViewController {

    let categories = [
        "All",
        "Bodycare",
        "Cleaning",
        "Stationary",
        "Gardening",
        "Supplements",
        "Accessories",
        "Food",
        "Hygiene",
        "Electronics"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCategoryProducts",
           let destinationVC = segue.destination as? ProductSearchTableViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let selectedCategory = categories[indexPath.row]
            destinationVC.selectedCategory = selectedCategory
        }
    }
}

