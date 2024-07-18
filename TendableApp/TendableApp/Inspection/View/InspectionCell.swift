//
//  InspectionCell.swift
//  TendableApp
//
//  Created by Menti on 16/07/24.
//

import UIKit

class InspectionCell: UITableViewCell {

    @IBOutlet weak var lblQuesion: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var btnOptions: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
