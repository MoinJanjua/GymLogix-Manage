//
//  ShowGymExpTableViewCell.swift
//  GymLogix Manage
//
//  Created by Farrukh on 07/11/2024.
//

import UIKit

class ShowGymExpTableViewCell: UITableViewCell {

    @IBOutlet weak var shimg: UIImageView!
    @IBOutlet weak var rentlbl: UILabel!
    @IBOutlet weak var empsalarylbl: UILabel!
    @IBOutlet weak var utilitieslbl: UILabel!
    @IBOutlet weak var equipmentlbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
