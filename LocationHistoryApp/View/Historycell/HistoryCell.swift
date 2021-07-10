//
//  HistoryCell.swift
//  LocationHistoryApp
//
//  Created by Mahipal sinh on 10/07/21.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
