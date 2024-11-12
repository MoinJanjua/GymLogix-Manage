//
//  SeeDetailSellPTableViewCell.swift
//  GymLogix Manage
//
//  Created by Farrukh on 07/11/2024.
//

import UIKit

class SeeDetailSellPTableViewCell: UITableViewCell {

    
    @IBOutlet weak var sdpimg: UIImageView!
    @IBOutlet weak var productnamelbl: UILabel!
    @IBOutlet weak var buyernamelbl: UILabel!
    @IBOutlet weak var amountlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
