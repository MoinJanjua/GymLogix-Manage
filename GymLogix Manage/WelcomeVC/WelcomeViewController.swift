//
//  WelcomeViewController.swift
//  GymLogix Manage
//
//  Created by Farrukh on 01/11/2024.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var startbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func startbutton(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
            dashboardVC.modalPresentationStyle = .fullScreen
            dashboardVC.modalTransitionStyle = .crossDissolve
            self.present(dashboardVC, animated: true, completion: nil)
        }
        
    }
}
