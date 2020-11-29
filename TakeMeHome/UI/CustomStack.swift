//
//  CustomStack.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/28.
//

import Foundation

class CustomStack : UIStackView{
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 3
        //self.layer.backgroundColor = UIColor.lightGray.cgColor
        
    }
     
}
