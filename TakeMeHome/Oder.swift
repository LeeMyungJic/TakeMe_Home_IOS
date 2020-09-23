//
//  Oders.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/23.
//

import Foundation

class Oder {
    let arrivalTime: String?
    let address: String?
    let price: Int?
    let methodOfPayment: String?
    let phone: String?
    let requirement: String?
    init(arrivalTime: String, address: String, price: Int, methodOfPayment: String, phone: String, requirement: String) {
        
        self.arrivalTime = arrivalTime
        self.address = address
        self.price = price
        self.methodOfPayment = methodOfPayment
        self.phone = phone
        self.requirement = requirement
    }
}
