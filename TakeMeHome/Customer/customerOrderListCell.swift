//
//  customerOrderListCell.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/12/03.
//

import UIKit

class customerOrderListCell: UITableViewCell {

    @IBOutlet var time: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
