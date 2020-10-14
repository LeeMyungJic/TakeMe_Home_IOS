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
    let oderCode: String?
    
    static var Orders = [Oder(arrivalTime: "14:35", address: "인천광역시 남동구 인주대로 857 동아아파트 111동 702호", price: 54000, methodOfPayment: "현금", phone: "010-5529-1234", requirement: "빨리 줘", oderCode: "Y21C"), Oder(arrivalTime: "14:20", address: "인천광역시 남동구 인주대로 857 삼환아파트 105동 1308호", price: 22800, methodOfPayment: "카드", phone: "010-8013-5170", requirement: "조심해서 오세요", oderCode: "A32P"), Oder(arrivalTime: "15:12", address: "인천광역시 남동구 인주대로 857 현광아파트 201동 501호", price: 12500, methodOfPayment: "카드", phone: "010-8013-5170", requirement: "조심해서 오세요", oderCode: "Y23B"), Oder(arrivalTime: "14:20", address: "인천광역시 남동구 인주대로 857 삼환아파트 105동 1308호", price: 33000, methodOfPayment: "카드", phone: "010-1234-5678", requirement: "조심해서 오세요", oderCode: "T24A")]
    
    init(arrivalTime: String, address: String, price: Int, methodOfPayment: String, phone: String, requirement: String, oderCode: String) {
        
        self.arrivalTime = arrivalTime
        self.address = address
        self.price = price
        self.methodOfPayment = methodOfPayment
        self.phone = phone
        self.requirement = requirement
        self.oderCode = oderCode
    }
}
