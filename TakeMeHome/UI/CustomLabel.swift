//
//  CustomLabel.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/12/22.
//

import UIKit

class CustomLabel: UILabel {

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        let colorLiteral = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        self.layer.cornerRadius = 3
        self.layer.borderColor = colorLiteral.cgColor
        self.layer.borderWidth = 1
        
        
    }

}
