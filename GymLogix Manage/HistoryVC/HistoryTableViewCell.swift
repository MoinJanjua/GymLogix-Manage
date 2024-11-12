//
//  HistoryTableViewCell.swift
//  GymLogix Manage
//
//  Created by Farrukh on 04/11/2024.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var descriptionlbl: UILabel!
    @IBOutlet weak var reasonlbl: UILabel!
    @IBOutlet weak var gymfeelbl: UILabel!
    @IBOutlet weak var trainerfeelbl: UILabel!
    @IBOutlet weak var paidAmountlbl: UILabel!
    @IBOutlet weak var balanceAmountlbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    
    @IBOutlet weak var genderlbl: UILabel!
    @IBOutlet weak var gympurposelbl: UILabel!
    @IBOutlet weak var agelbl: UILabel!
    @IBOutlet weak var heightlbl: UILabel!
    @IBOutlet weak var trainerlbl: UILabel!
    @IBOutlet weak var weightlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
