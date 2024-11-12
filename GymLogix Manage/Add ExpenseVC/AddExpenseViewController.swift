//
//  AddExpenseViewController.swift
//  GymLogix Manage
//
//  Created by Farrukh on 03/11/2024.
//

import UIKit

class AddExpenseViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titletextfield: UITextField!
    @IBOutlet weak var descriptiontextfield: UITextField!
    //@IBOutlet weak var reasonDropDown: DropDown!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var gymfeetextfield: UITextField!
    @IBOutlet weak var trainertextfield: UITextField!
    @IBOutlet weak var paidamounttextfield: UITextField!
    @IBOutlet weak var balanceamounttextfield: UITextField!

    // New property to determine trainer selection
       var isWithTrainerSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show or hide trainertextfield based on the trainer selection
        trainertextfield.isHidden = !isWithTrainerSelected
        
        // Set the keyboard type for number-only fields
           gymfeetextfield.keyboardType = .numberPad
           trainertextfield.keyboardType = .numberPad
           paidamounttextfield.keyboardType = .numberPad
       // reasonDropDown.optionArray = ["Electricity Bill", "Groceries Exp"]
        //reasonDropDown.didSelect { (selectedText, index, id) in
           // self.reasonDropDown.text = selectedText
        
        //reasonDropDown.delegate = self
        
        // Set delegates for text fields
        gymfeetextfield.delegate = self
        trainertextfield.delegate = self
        paidamounttextfield.delegate = self
        
        // Add target actions for real-time updates
        gymfeetextfield.addTarget(self, action: #selector(updateBalance), for: .editingChanged)
        trainertextfield.addTarget(self, action: #selector(updateBalance), for: .editingChanged)
        paidamounttextfield.addTarget(self, action: #selector(updateBalance), for: .editingChanged)
    }

    @objc func updateBalance() {
        // Get values from text fields, default to 0 if empty
        let gymFee = Double(gymfeetextfield.text ?? "") ?? 0.0
        let trainerFee = Double(trainertextfield.text ?? "") ?? 0.0
        let paidAmount = Double(paidamounttextfield.text ?? "") ?? 0.0
        
        // Calculate the balance amount
        let totalFee = gymFee + trainerFee
        let balanceAmount = paidAmount > 0 ? totalFee - paidAmount : totalFee
        
        // Display the balance in the balanceamounttextfield
        balanceamounttextfield.text = String(format: "%.2f", balanceAmount)
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
            dashboardVC.modalPresentationStyle = .fullScreen
            dashboardVC.modalTransitionStyle = .crossDissolve
            self.present(dashboardVC, animated: true, completion: nil)
        }
    }
    @IBAction func savebutton(_ sender: UIButton) {
        // Check if mandatory fields are filled
        guard let title = titletextfield.text, !title.isEmpty
               else {
            // Show alert if mandatory fields are missing
            let alert = UIAlertController(title: "Error", message: "Please fill in the mandatory fields (Title and Reason).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Use `updateBalance()` logic here if needed to ensure balance is updated

        // Create a new `Profiles` instance using the data from text fields
        let gender = UserDefaults.standard.string(forKey: "selectedGender") ?? "Male"
        let gymPurpose = UserDefaults.standard.string(forKey: "selectedGymPurpose") ?? "Weight Gain"
        let trainer = UserDefaults.standard.string(forKey: "selectedTrainer") ?? "With Trainer"
        let weight = UserDefaults.standard.string(forKey: "userWeight") ?? "Weight: Not set"
        let age = UserDefaults.standard.string(forKey: "userAge") ?? "Male"
        let height = UserDefaults.standard.string(forKey: "userHeight") ?? "Male"
        let heightUnit = UserDefaults.standard.string(forKey: "heightUnit") ?? "Centimeters"
        
        let newProfile = Profiles(
            name: title,
            date: datepicker.date,
            description: descriptiontextfield.text ?? "",
            gymfee: gymfeetextfield.text ?? "",
            trainerfee: trainertextfield.text ?? "",
            paidamount: paidamounttextfield.text ?? "",
            balanceamount: balanceamounttextfield.text ?? "",
            gender:gender,
            gympurpose: gymPurpose,
            trainer: trainer,
            age:age,
            height: height,
            weight: weight
            
        )
        
        // Save the newProfile to `UserDefaults`
        var existingProfiles: [Profiles] = []
        if let data = UserDefaults.standard.data(forKey: "gymExpenses"),
           let decodedProfiles = try? JSONDecoder().decode([Profiles].self, from: data) {
            existingProfiles = decodedProfiles
        }
        existingProfiles.append(newProfile)
        if let encodedData = try? JSONEncoder().encode(existingProfiles) {
            UserDefaults.standard.set(encodedData, forKey: "gymExpenses")
        }
        
        // Show success message
        let alert = UIAlertController(title: "Success", message: "Record added successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        // Clear all fields after saving
        clearFields()
    }

    private func clearFields() {
        titletextfield.text = ""
        descriptiontextfield.text = ""

        gymfeetextfield.text = ""
        trainertextfield.text = ""
        paidamounttextfield.text = ""
        balanceamounttextfield.text = ""
        datepicker.setDate(Date(), animated: true)
    }
}
