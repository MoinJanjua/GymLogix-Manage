import UIKit

class GenderViewController: UIViewController {
    
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var nextbutton: UIButton!
    
    var selecteditem: [String] = [] // Variable to hold the user's selected gender
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the default state to "Male"
        genderImage.image = UIImage(named: "maleimage") // Replace with actual male image name
        selecteditem = ["Male"] // Store the selected gender
        
        // Set the initial button states (Male button should be selected)
        maleButton.isSelected = true
        femaleButton.isSelected = false
        // Save default value to UserDefaults
        UserDefaults.standard.setValue("Male", forKey: "selectedGender")
    }
    
    @IBAction func maleButtonTapped(_ sender: UIButton) {
        // Change the gender image to male
        genderImage.image = UIImage(named: "maleimage") // Replace with actual male image name
        
        // Update the selected gender in selecteditem
        selecteditem = ["Male"]
        
        // Update the button states (Male button selected, Female button deselected)
        maleButton.isSelected = true
        femaleButton.isSelected = false
        // Save selected gender to UserDefaults
        UserDefaults.standard.setValue("Male", forKey: "selectedGender")
    }
    
    @IBAction func femaleButtonTapped(_ sender: UIButton) {
        // Change the gender image to female
        genderImage.image = UIImage(named: "femaleimage") // Replace with actual female image name
        
        // Update the selected gender in selecteditem
        selecteditem = ["Female"]
        
        // Update the button states (Male button deselected, Female button selected)
        maleButton.isSelected = false
        femaleButton.isSelected = true
        // Save selected gender to UserDefaults
        UserDefaults.standard.setValue("Female", forKey: "selectedGender")
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // Proceed to the next view controller (GymPurposeViewController)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let gymVC = storyBoard.instantiateViewController(withIdentifier: "GymPurposeViewController") as? GymPurposeViewController {
            gymVC.modalPresentationStyle = .fullScreen
            gymVC.modalTransitionStyle = .crossDissolve
            self.present(gymVC, animated: true, completion: nil)
        }
        
    }
    @IBAction func BackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
