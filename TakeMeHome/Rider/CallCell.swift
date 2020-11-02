//
//  CallCell.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/22.
//

import UIKit

class CallCell: UITableViewCell {

    @IBOutlet var storeNameStr: UILabel!
    @IBOutlet var storeAddress: UILabel!
    @IBOutlet var timeStr: UILabel!
    
    @IBOutlet var stack: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
