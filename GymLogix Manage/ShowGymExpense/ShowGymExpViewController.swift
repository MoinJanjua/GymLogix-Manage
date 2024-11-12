import UIKit

class ShowGymExpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var Tv: UITableView!
    @IBOutlet weak var nodatalbl: UILabel!
    @IBOutlet weak var deletall: UIButton!
    
    var gymexp: [gymexpense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Tv.dataSource = self
        Tv.delegate = self
        loadGymExpenses()
    }
    
    @IBAction func backbtnn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deletall(_ sender: UIButton) {
        // Clear all expenses
        UserDefaults.standard.removeObject(forKey: "shogymExpenses")
        gymexp.removeAll()
        Tv.reloadData()
        nodatalbl.isHidden = false
    }
    
    // Load saved gym expenses from UserDefaults
    private func loadGymExpenses() {
        if let data = UserDefaults.standard.data(forKey: "shogymExpenses"),
           let expenses = try? JSONDecoder().decode([gymexpense].self, from: data) {
            gymexp = expenses
            nodatalbl.isHidden = !gymexp.isEmpty
            Tv.reloadData()
        } else {
            nodatalbl.isHidden = false
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gymexp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowGymExpTableViewCell
        let expense = gymexp[indexPath.row]
        
        // Populate cell labels with expense data
        cell.rentlbl.text = "\(expense.rent)"
        cell.empsalarylbl.text = "Desc: \(expense.employeesalary)"
        cell.utilitieslbl.text = "Utilities: \(expense.utilities)"
        cell.equipmentlbl.text = "Amount: \(expense.equipmentandmaintenance)"
        
        // Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.datelbl.text = "Date: \(dateFormatter.string(from: expense.date))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           
           // Create delete action
           let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
               guard let self = self else { return }
               
               // Delete the profile from the array
               self.gymexp.remove(at: indexPath.row)
               
               // Save the updated profiles array to UserDefaults
               if let encodedProfiles = try? JSONEncoder().encode(self.gymexp) {
                   UserDefaults.standard.set(encodedProfiles, forKey: "shogymExpenses")
               }
               
               // Reload the table view
               self.Tv.deleteRows(at: [indexPath], with: .automatic)
               
               // Show or hide the no data label based on whether profiles exist
               self.nodatalbl.isHidden = !self.gymexp.isEmpty
               
               // Complete the swipe action
               completionHandler(true)
           }
           
           deleteAction.backgroundColor = .red
           
           // Return swipe actions configuration
           let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
           return swipeActions
       }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
