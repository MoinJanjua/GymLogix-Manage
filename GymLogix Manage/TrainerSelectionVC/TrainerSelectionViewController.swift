import UIKit

class TrainerSelectionViewController: UIViewController {

    @IBOutlet weak var withtrainerbutton: UIButton!
    @IBOutlet weak var trimg: UIImageView!
    @IBOutlet weak var withouttrainerbutton: UIButton!
    
    var selectedTrainer: String? // Variable to store the selected trainer option

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set default selection: with trainer
        trimg.image = UIImage(named: "withtrainer_image") // Set the default image for "with trainer"
        selectedTrainer = "With Trainer" // Set the default selection value
        
        // Save the default value to UserDefaults
        UserDefaults.standard.set("With Trainer", forKey: "selectedTrainer")
        
        // Ensure the "with trainer" button is visually selected
        withtrainerbutton.isSelected = true
        withouttrainerbutton.isSelected = false
    }
    
    // Back button action
    @IBAction func backbtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // Action for "with trainer" button
    @IBAction func withtrainerbutton(_ sender: UIButton) {
        // Set the corresponding image
        trimg.image = UIImage(named: "withtrainer_image") // Replace with your actual with trainer image name
        selectedTrainer = "With Trainer"
        
        // Update button selection
        withtrainerbutton.isSelected = true
        withouttrainerbutton.isSelected = false
        
        // Save the selected trainer option to UserDefaults
        UserDefaults.standard.set("With Trainer", forKey: "selectedTrainer")
    }
    
    // Action for "without trainer" button
    @IBAction func withouttrainerbutton(_ sender: UIButton) {
        // Set the corresponding image
        trimg.image = UIImage(named: "withouttrainer_image") // Replace with your actual without trainer image name
        selectedTrainer = "Without Trainer"
        
        // Update button selection
        withtrainerbutton.isSelected = false
        withouttrainerbutton.isSelected = true
        
        // Save the selected trainer option to UserDefaults
        UserDefaults.standard.set("Without Trainer", forKey: "selectedTrainer")
    }
    
    // Action for "next" button to move to AgeandHeightViewController
    @IBAction func nextbttn(_ sender: UIButton) {
        // Navigate to the next view controller (AgeandHeightViewController)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let ageVC = storyBoard.instantiateViewController(withIdentifier: "AgeandHeightViewController") as? AgeandHeightViewController {
            ageVC.modalPresentationStyle = .fullScreen
            ageVC.modalTransitionStyle = .crossDissolve
            self.present(ageVC, animated: true, completion: nil)
        }
    }
}
