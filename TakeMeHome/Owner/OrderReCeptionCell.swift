//
//  OrderReCeptionCell.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/09.
//

import UIKit

class OrderReCeptionCell: UITableViewCell {

    @IBOutlet var stack: UIStackView!
    @IBOutlet var address: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var number: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
