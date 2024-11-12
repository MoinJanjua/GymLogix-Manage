import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var Tv: UITableView!
    @IBOutlet weak var nodatalbl: UILabel!
    
    // Array to hold loaded profiles from UserDefaults
    var profiles: [Profiles] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        Tv.dataSource = self
        Tv.delegate = self
        
        // Load saved data from UserDefaults
        loadProfiles()
    }

    func loadProfiles() {
        if let data = UserDefaults.standard.data(forKey: "gymExpenses"),
           let decodedProfiles = try? JSONDecoder().decode([Profiles].self, from: data) {
            profiles = decodedProfiles
        } else {
            profiles = [] // If no data is found, initialize as an empty array
        }
        
        // Show or hide the no data label based on whether profiles exist
        if profiles.isEmpty {
            nodatalbl.isHidden = false
            nodatalbl.text = "No records available."
        } else {
            nodatalbl.isHidden = true
        }
        
        Tv.reloadData() // Refresh the table view with new data
    }

    @IBAction func backbtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteAllbtn(_ sender: UIButton) {
        // Clear all data from UserDefaults and refresh the table view
        UserDefaults.standard.removeObject(forKey: "gymExpenses")
        profiles = []
        
        // Show or hide the no data label based on whether profiles exist
        nodatalbl.isHidden = !profiles.isEmpty
        Tv.reloadData()
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        // Get the profile for the current row
        let profile = profiles[indexPath.row]
        
        // Configure cell UI elements with profile data
        cell.titlelbl.text = "Name: \(profile.name)"
        cell.descriptionlbl.text = "\(profile.description)"
        cell.gymfeelbl.text = "Gym Fee: \(profile.gymfee)"
        cell.trainerfeelbl.text = "Trainer Fee: \(profile.trainerfee)"
        cell.paidAmountlbl.text = "Paid Am: \(profile.paidamount)"
        cell.balanceAmountlbl.text = "Balance: \(profile.balanceamount)"
        cell.datelbl.text = formatDate(profile.date) // Format date for display
        
        // Retrieve and set labels from UserDefaults (gender, gym purpose, etc.)
        cell.genderlbl.text = "Gender: \(profile.gender)"
        cell.gympurposelbl.text = "Gym Purpose: \(profile.gympurpose)"
        cell.trainerlbl.text = "Trainer: \(profile.trainer)"
        cell.weightlbl.text = "Weight: \(profile.weight) kg"
        cell.agelbl.text = "Age: \(profile.age)"
        cell.heightlbl.text = "Height: \(profile.height)    "
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           
           // Create delete action
           let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
               guard let self = self else { return }
               
               // Delete the profile from the array
               self.profiles.remove(at: indexPath.row)
               
               // Save the updated profiles array to UserDefaults
               if let encodedProfiles = try? JSONEncoder().encode(self.profiles) {
                   UserDefaults.standard.set(encodedProfiles, forKey: "gymExpenses")
               }
               
               // Reload the table view
               self.Tv.deleteRows(at: [indexPath], with: .automatic)
               
               // Show or hide the no data label based on whether profiles exist
               self.nodatalbl.isHidden = !self.profiles.isEmpty
               
               // Complete the swipe action
               completionHandler(true)
           }
           
           deleteAction.backgroundColor = .red
           
           // Return swipe actions configuration
           let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
           return swipeActions
       }

    // Helper method to format Date to a readable string
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    

    // Method to handle saving a new record and appending it to the profile list
    func saveNewProfile(profile: Profiles) {
        // Add new profile to the array
        profiles.append(profile)
        
        // Save updated profiles list to UserDefaults
        if let encodedProfiles = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encodedProfiles, forKey: "gymExpenses")
        }

        // Reload the table view to show the new record
        Tv.reloadData()
    }
}
