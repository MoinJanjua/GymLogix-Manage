import UIKit

class AddWeightViewController: UIViewController {

    @IBOutlet weak var adjustWeightview: UIView!
    @IBOutlet weak var adjustweightSlider: UISlider!
    @IBOutlet weak var showweightlbl: UILabel!

    @IBOutlet weak var nextbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the slider with min, max, and default values
        adjustweightSlider.minimumValue = 20
        adjustweightSlider.maximumValue = 250
        adjustweightSlider.value = 65 // Set default value to 65 kg
        
        // Display initial slider value in label
        showweightlbl.text = "\(Int(adjustweightSlider.value)) kg"
        
        // Add target to handle value change in real-time
        adjustweightSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        // Retrieve saved weight if available
        if let savedWeight = UserDefaults.standard.value(forKey: "userWeight") as? Float {
            adjustweightSlider.value = savedWeight
            showweightlbl.text = "\(Int(savedWeight)) kg"
        }
    }

    // Method to update label and save value when slider changes
    @objc func sliderValueChanged(_ sender: UISlider) {
        let weight = Int(sender.value)
        showweightlbl.text = "\(weight) kg"
        
        // Save the weight to UserDefaults
        UserDefaults.standard.set(sender.value, forKey: "userWeight")
    }
    
    @IBAction func nextbutton(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let addExpenseVC = storyBoard.instantiateViewController(withIdentifier: "AddExpenseViewController") as? AddExpenseViewController {
            addExpenseVC.modalPresentationStyle = .fullScreen
            addExpenseVC.modalTransitionStyle = .crossDissolve
            
            // Pass the trainer selection from UserDefaults to AddExpenseViewController
            let selectedTrainer = UserDefaults.standard.string(forKey: "selectedTrainer") ?? "Without Trainer"
            addExpenseVC.isWithTrainerSelected = (selectedTrainer == "With Trainer")
            
            self.present(addExpenseVC, animated: true, completion: nil)
        }
    }

    @IBAction func BacKBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
