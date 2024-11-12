import UIKit

class AgeandHeightViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var agetextfield: UITextField!
    @IBOutlet weak var chooseheightunitDropDown: DropDown!
    @IBOutlet weak var adjustheightSlider: UISlider!
    @IBOutlet weak var showheightlbl: UILabel!
    @IBOutlet weak var nextnutton: UIButton!

    var age: Int = 0
    var heightUnit: String = "Centimeters" // Default unit
    var height: Int = 170 // Default height in cm
    var heightString: String = "170"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial display
        setupSlider(for: heightUnit)
        showHeightLabel()
        
        agetextfield.delegate = self
        agetextfield.keyboardType = .numberPad

        // Dropdown setup
        chooseheightunitDropDown.optionArray = ["Centimeters", "Feet and inches"]
        chooseheightunitDropDown.didSelect { [weak self] (selectedText, index, id) in
            self?.heightUnit = selectedText
            self?.setupSlider(for: selectedText)
            self?.showHeightLabel()
        }

        // Slider value change handler
        adjustheightSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }

    // Setup slider range and default value based on unit
    func setupSlider(for unit: String) {
        if unit == "Centimeters" {
            adjustheightSlider.minimumValue = 100
            adjustheightSlider.maximumValue = 250
            adjustheightSlider.value = 170 // Default to 170 cm
            height = Int(adjustheightSlider.value)
        } else if unit == "Feet and inches" {
            adjustheightSlider.minimumValue = 36 // 3 feet
            adjustheightSlider.maximumValue = 96 // 8 feet
            adjustheightSlider.value = 66 // Default to 5 ft 6 in
            height = Int(adjustheightSlider.value)
        }
    }

    // Update height label with current slider value and unit
    @objc func sliderValueChanged(_ sender: UISlider) {
        height = Int(sender.value)
        showHeightLabel()
    }

    // Display height with the selected unit
    func showHeightLabel() {
        if heightUnit == "Centimeters" {
            showheightlbl.text = "\(height) cm"
            heightString = "\(height) cm"
        } else if heightUnit == "Feet and inches" {
            let feet = height / 12
            let inches = height % 12
            showheightlbl.text = "\(feet) ft \(inches) in"
            heightString = "\(feet) ft \(inches) in"
        }
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // Save age, height, and height unit to UserDefaults when moving to the next view controller
    @IBAction func nextnutton(_ sender: UIButton) {
        UserDefaults.standard.set(age, forKey: "userAge")
        UserDefaults.standard.set(heightString, forKey: "userHeight")
        UserDefaults.standard.set(heightUnit, forKey: "heightUnit")

        // Navigate to the next view controller
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let weightVC = storyBoard.instantiateViewController(withIdentifier: "AddWeightViewController") as? AddWeightViewController {
            weightVC.modalPresentationStyle = .fullScreen
            weightVC.modalTransitionStyle = .crossDissolve
            self.present(weightVC, animated: true, completion: nil)
        }
    }

    // UITextFieldDelegate to capture age input
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let ageText = textField.text, let ageValue = Int(ageText) {
            age = ageValue
            UserDefaults.standard.set(age, forKey: "userAge")
        }
    }

    // Dismiss keyboard when tapping outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
