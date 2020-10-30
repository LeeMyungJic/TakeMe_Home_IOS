//
//  Stores.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/10/30.
//

import Foundation

class Store {
    private let storeName : String?
    static var Stores = [String]()
    init (storeName : String) {
        self.storeName = storeName
    }
}
