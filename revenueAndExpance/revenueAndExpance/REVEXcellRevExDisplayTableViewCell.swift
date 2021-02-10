//
//  REVEXcellRevExDisplayTableViewCell.swift
//  revenueAndExpance
//
//  Created by Vijay on 10/02/21.
//

import UIKit

class REVEXcellRevExDisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var lbtItemName: UILabel!
    @IBOutlet weak var lblItemDate: UILabel!
    @IBOutlet weak var lblItemAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
