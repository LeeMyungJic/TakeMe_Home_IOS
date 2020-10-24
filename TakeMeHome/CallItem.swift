//
//  CallItems.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/23.
//

import Foundation

class CallItem {
    let address: String?
    let storeName: String?
    let cookingTime: String?
    let latitude: Double?
    let longitude: Double?
    let oderCode: String?
    
    
    static var callItems = [CallItem(address: "인천광역시 남동구 만수동", storeName: "한신포차 만수점", latitude: 37.44923885384186, longitude: 126.73117584962965, cookingTime: "12:42", odercode: "T24A"),CallItem(address: "인천광역시 남동구 만수동", storeName: "신포닭발 굳", latitude: 37.44869300832446, longitude: 126.73283907950601, cookingTime: "14:21", odercode: "Y23B"), CallItem(address: "인천광역시 남동구 만수동", storeName: "박재성의 집", latitude: 37.44768636596332, longitude: 126.73294436870398, cookingTime: "17:46", odercode: "A32P"), CallItem(address: "인천광역시 남동구 구월동", storeName: "구월4동 행정복지센터", latitude: 37.44964822199389, longitude: 126.72407714054171, cookingTime: "13:22", odercode: "Y21C")]
    
    
    init(address:String, storeName:String, latitude:Double, longitude:Double, cookingTime: String, odercode: String){
        self.address = address
        self.storeName = storeName
        self.latitude = latitude
        self.longitude = longitude
        self.cookingTime = cookingTime
        self.oderCode = odercode

    }
}
