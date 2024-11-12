import UIKit

class SeeDetailSellPViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var Tv: UITableView!
    @IBOutlet weak var nodatalbl: UILabel!
    
    var products: [sellproduct] = [] // Array to hold the products
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Tv.dataSource = self
        Tv.delegate = self
        
        // Load the saved products from UserDefaults
        loadProducts()
    }
    
    
    
    // Load saved products from UserDefaults
    private func loadProducts() {
        if let data = UserDefaults.standard.data(forKey: "soldProducts"),
           let savedProducts = try? JSONDecoder().decode([sellproduct].self, from: data) {
            products = savedProducts
            // If products exist, hide the "No Data" label, otherwise show it
            nodatalbl.isHidden = !products.isEmpty
            Tv.reloadData()
        } else {
            nodatalbl.isHidden = false
        }
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteAllbtn(_ sender: UIButton) {
        // Clear all saved products
        UserDefaults.standard.removeObject(forKey: "soldProducts")
        products.removeAll()
        Tv.reloadData()
        nodatalbl.isHidden = false
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SeeDetailSellPTableViewCell
        let product = products[indexPath.row]
        
        // Set cell data with product details
        cell.productnamelbl.text = "Product: \(product.productname)"
        cell.buyernamelbl.text = "Buyer: \(product.byuername)"
        cell.amountlbl.text = "Amount: \(product.amount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           
           // Create delete action
           let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
               guard let self = self else { return }
               
               // Delete the profile from the array
               self.products.remove(at: indexPath.row)
               
               // Save the updated profiles array to UserDefaults
               if let encodedProfiles = try? JSONEncoder().encode(self.products) {
                   UserDefaults.standard.set(encodedProfiles, forKey: "soldProducts")
               }
               
               // Reload the table view
               self.Tv.deleteRows(at: [indexPath], with: .automatic)
               
               // Show or hide the no data label based on whether profiles exist
               self.nodatalbl.isHidden = !self.products.isEmpty
               
               // Complete the swipe action
               completionHandler(true)
           }
           
           deleteAction.backgroundColor = .red
           
           // Return swipe actions configuration
           let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
           return swipeActions
       }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
