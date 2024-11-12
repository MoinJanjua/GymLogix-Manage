import UIKit

class SellProductViewController: UIViewController {

    @IBOutlet weak var productnamelbl: UILabel!
    @IBOutlet weak var productnameTF: UITextField!
    @IBOutlet weak var buyernamelbl: UILabel!
    @IBOutlet weak var buyernameDropdown: DropDown!
    @IBOutlet weak var amountlbl: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var datepicker: UIDatePicker!

    var names = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfiles()
        
        // Set the keyboard type for number-only fields
        amountTF.keyboardType = .numberPad
        // Configure date picker mode for date selection only
        datepicker.datePickerMode = .date
    }

    func loadProfiles() {
        if let data = UserDefaults.standard.data(forKey: "gymExpenses"),
           let decodedProfiles = try? JSONDecoder().decode([Profiles].self, from: data) {
            let namelist = decodedProfiles.map { $0.name }
            names = namelist
        } else {
            names = []
        }
        
        setupDropDowns()
    }

    private func setupDropDowns() {
        buyernameDropdown.optionArray = names
    }

    @IBAction func savebtn(_ sender: UIButton) {
        // Retrieve values from text fields, dropdown, and date picker
        guard let productName = productnameTF.text, !productName.isEmpty,
              let amount = amountTF.text, !amount.isEmpty,
              let selectedBuyer = buyernameDropdown.text, !selectedBuyer.isEmpty else {
            showAlert("Please fill in all fields.")
            return
        }

        // Get the selected date from the date picker
        let selectedDate = datepicker.date
        
        // Create a new sellproduct instance with the selected date
        let newProduct = sellproduct(
            productname: productName,
            byuername: selectedBuyer,
            amount: amount,
            date: selectedDate
        )

        // Save the new product record
        saveProduct(newProduct)
        
        // Clear all fields after saving
        clearFields()

        // Show success message
        showAlert("Product sold successfully.")
    }

    private func saveProduct(_ product: sellproduct) {
        var savedProducts = getSavedProducts() ?? []
        savedProducts.append(product)
        
        if let encodedData = try? JSONEncoder().encode(savedProducts) {
            UserDefaults.standard.set(encodedData, forKey: "soldProducts")
        }
    }

    private func getSavedProducts() -> [sellproduct]? {
        if let data = UserDefaults.standard.data(forKey: "soldProducts"),
           let products = try? JSONDecoder().decode([sellproduct].self, from: data) {
            return products
        }
        return nil
    }

    private func clearFields() {
        productnameTF.text = ""
        amountTF.text = ""
        buyernameDropdown.text = ""
        datepicker.setDate(Date(), animated: true)  // Resets date picker to today's date
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func bkbtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
