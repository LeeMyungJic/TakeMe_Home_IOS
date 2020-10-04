//
//  AcceptanceCell.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/29.
//

import UIKit

class AcceptanceCell: UITableViewCell {

    @IBOutlet var stack: UIStackView!
    @IBOutlet var nameStr: UILabel!
    @IBOutlet var addressStr: UILabel!
    @IBOutlet var Time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
