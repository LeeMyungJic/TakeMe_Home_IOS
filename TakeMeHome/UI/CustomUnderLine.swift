//
//  CustomUnderLine.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/28.
//

import Foundation

class CustomUnderLine : UITextField{
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        let border = CALayer()

        let width = CGFloat(1.0)

        border.borderColor = UIColor.lightGray.cgColor

        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)



        border.borderWidth = width
        self.layer.addSublayer(border)

        self.layer.masksToBounds = true
        
    }
     
}
