//
//  Oders.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/23.
//

import Foundation

class Order {
    let storeName: String?
    let storeAddress: String?
    let cookingTime: String?
    let latitude: Double?
    let longitude: Double?
    let oderCode: String?
    let arrivalTime: String?
    let destinationAddress: String?
    let price: Int?
    let methodOfPayment: String?
    let phone: String?
    let requirement: String?
    
    static var Orders = [Order(arrivalTime: "14:35", destinationAddress: "인천광역시 남동구 인주대로 857 동아아파트 111동 702호", price: 54000, methodOfPayment: "현금", phone: "010-5529-1234", requirement: "빨리 줘", oderCode: "Y21C", storeAddress: "인천광역시 남동구 만수1동", storeName: "한신포차", latitude: 37.44923885384186, longitude: 126.73117584962965, cookingTime: "12:42"), Order(arrivalTime: "14:20", destinationAddress: "인천광역시 남동구 인주대로 857 삼환아파트 105동 1308호", price: 22800, methodOfPayment: "카드", phone: "010-8013-5170", requirement: "조심해서 오세요", oderCode: "A32P", storeAddress: "인천광역시 남동구 만수3동", storeName: "신포닭발", latitude: 37.44869300832446, longitude: 126.73283907950601, cookingTime: "14:21"), Order(arrivalTime: "15:12", destinationAddress: "인천광역시 남동구 인주대로 857 현광아파트 201동 501호", price: 12500, methodOfPayment: "카드", phone: "010-8013-5170", requirement: "조심해서 오세요", oderCode: "Y23B", storeAddress: "인천광역시 남동구 만수동", storeName: "한신포차", latitude: 37.44768636596332, longitude: 126.73294436870398, cookingTime: "17:46"), Order(arrivalTime: "14:20", destinationAddress: "인천광역시 남동구 인주대로 857 삼환아파트 105동 1308호", price: 33000, methodOfPayment: "카드", phone: "010-1234-5678", requirement: "어서와요", oderCode: "T24A", storeAddress: "인천광역시 남동구 구월동", storeName: "1943", latitude: 37.44964822199389, longitude: 126.72407714054171, cookingTime: "13:22")]
    
    init(arrivalTime: String, destinationAddress: String, price: Int, methodOfPayment: String, phone: String, requirement: String, oderCode: String,  storeAddress: String, storeName: String, latitude: Double, longitude: Double, cookingTime: String) {
        
        self.arrivalTime = arrivalTime
        self.destinationAddress = destinationAddress
        self.price = price
        self.methodOfPayment = methodOfPayment
        self.phone = phone
        self.requirement = requirement
        self.oderCode = oderCode
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.latitude = latitude
        self.longitude = longitude
        self.cookingTime = cookingTime
    }
}
