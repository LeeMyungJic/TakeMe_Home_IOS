//
//  StoreDetailCell.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/10.
//

import UIKit

class StoreDetailCell: UITableViewCell {

    @IBOutlet var Name: UILabel!
    @IBOutlet var Price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
