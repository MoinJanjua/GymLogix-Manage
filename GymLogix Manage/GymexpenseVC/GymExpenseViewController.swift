import UIKit

class GymExpenseViewController: UIViewController {

    @IBOutlet weak var rentlbl: UILabel!
    @IBOutlet weak var rentTF: UITextField!
    @IBOutlet weak var empsalary: UILabel!
    @IBOutlet weak var descritpionTF: UITextField!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var utilitieslbl: UILabel!
    @IBOutlet weak var utilitiesDropDown: DropDown!
    @IBOutlet weak var equipmentlbl: UILabel!
   
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var savebutton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDowns()
        // Set the keyboard type for number-only fields
           rentTF.keyboardType = .numberPad
           descritpionTF.keyboardType = .default
           amountTF.keyboardType = .numberPad
        
    }
    
    private func setupDropDowns() {
        utilitiesDropDown.optionArray = [
            "Electricity",
            "Water",
            "Internet",
            "Heating",
            "Cleaning",
            "Repairs",
            "Security",
            "Supplies",
            "Emp Salary",
            "Insurance Premiums",
            "Advertising and Marketing",
            "Telecommunications",
            "Office Supplies (e.g., paper, printer ink)",
            "Property Taxes",
            "Trainer Salary",
            "Others"
            
        ]
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Retrieve values from text fields, date picker, and dropdowns
        guard let rent = rentTF.text, !rent.isEmpty,
            
              let utilities = utilitiesDropDown.text,
              let equipment = amountTF.text else {
            // Show an alert if any required field is missing
            showAlert("Please fill in all fields.")
            return
        }
        
        let date = datepicker.date
        let desc = descritpionTF.text ?? "No Description"
        // Create a gymexpense instance
        let newExpense = gymexpense(rent: rent, date: date, employeesalary: desc, utilities: utilities, equipmentandmaintenance: equipment)
        
        // Save the data (for example, you could save it to UserDefaults or a database)
        saveExpense(newExpense)
        
        // Clear all fields
        clearFields()
        
        // Show success message
        showAlert("Expense saved successfully.")
    }
    
    @IBAction func bkbtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func saveExpense(_ expense: gymexpense) {
        // Here you can implement saving to UserDefaults or a database
        if var savedExpenses = getSavedExpenses() {
            savedExpenses.append(expense)
            if let encodedData = try? JSONEncoder().encode(savedExpenses) {
                UserDefaults.standard.set(encodedData, forKey: "shogymExpenses")
            }
        } else {
            let newExpensesList = [expense]
            if let encodedData = try? JSONEncoder().encode(newExpensesList) {
                UserDefaults.standard.set(encodedData, forKey: "shogymExpenses")
            }
        }
    }
    
    private func getSavedExpenses() -> [gymexpense]? {
        if let data = UserDefaults.standard.data(forKey: "shogymExpenses"),
           let expenses = try? JSONDecoder().decode([gymexpense].self, from: data) {
            return expenses
        }
        return nil
    }
    
    private func clearFields() {
        rentTF.text = ""
        descritpionTF.text = ""
        datepicker.date = Date() // Reset to current date
        utilitiesDropDown.text = ""
        amountTF.text = ""
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
