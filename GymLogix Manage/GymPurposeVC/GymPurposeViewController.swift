import UIKit

class GymPurposeViewController: UIViewController {

    @IBOutlet weak var weightgainbutton: UIButton!
    @IBOutlet weak var weightlossbutton: UIButton!
    @IBOutlet weak var fitnessbutton: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    var selectedPurpose: String? // Variable to store the selected gym purpose

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default selection: weight gain
        img.image = UIImage(named: "weightgain_image") // Set the default image for weight gain
        selectedPurpose = "Weight Gain" // Set the default purpose
        
        // Save the default value to UserDefaults
        UserDefaults.standard.set("Weight Gain", forKey: "selectedGymPurpose")
        
        // Make sure the weight gain button is visually selected
        weightgainbutton.isSelected = true
        weightlossbutton.isSelected = false
        fitnessbutton.isSelected = false
    }
    
    // Back button action
    @IBAction func backbtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // Action for weight gain button
    @IBAction func weightgainbutton(_ sender: UIButton) {
        // Set the corresponding image
        img.image = UIImage(named: "weightgain_image") // Replace with your actual weight gain image name
        selectedPurpose = "Weight Gain"
        
        // Update button selection
        weightgainbutton.isSelected = true
        weightlossbutton.isSelected = false
        fitnessbutton.isSelected = false
        
        // Save the selected gym purpose to UserDefaults
        UserDefaults.standard.set("Weight Gain", forKey: "selectedGymPurpose")
    }
    
    // Action for weight loss button
    @IBAction func weightlossbutton(_ sender: UIButton) {
        // Set the corresponding image
        img.image = UIImage(named: "weightloss_image") // Replace with your actual weight loss image name
        selectedPurpose = "Weight Loss"
        
        // Update button selection
        weightgainbutton.isSelected = false
        weightlossbutton.isSelected = true
        fitnessbutton.isSelected = false
        
        // Save the selected gym purpose to UserDefaults
        UserDefaults.standard.set("Weight Loss", forKey: "selectedGymPurpose")
    }
    
    // Action for fitness button
    @IBAction func fitnessbutton(_ sender: UIButton) {
        // Set the corresponding image
        img.image = UIImage(named: "fitness_image") // Replace with your actual fitness image name
        selectedPurpose = "Fitness"
        
        // Update button selection
        weightgainbutton.isSelected = false
        weightlossbutton.isSelected = false
        fitnessbutton.isSelected = true
        
        // Save the selected gym purpose to UserDefaults
        UserDefaults.standard.set("Fitness", forKey: "selectedGymPurpose")
    }
    
    // Action for next button to move to TrainerSelectionViewController
    @IBAction func nextbtn(_ sender: UIButton) {
        // Navigate to the next view controller (TrainerSelectionViewController)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let trainerVC = storyBoard.instantiateViewController(withIdentifier: "TrainerSelectionViewController") as? TrainerSelectionViewController {
            trainerVC.modalPresentationStyle = .fullScreen
            trainerVC.modalTransitionStyle = .crossDissolve
            self.present(trainerVC, animated: true, completion: nil)
        }
    }
}
