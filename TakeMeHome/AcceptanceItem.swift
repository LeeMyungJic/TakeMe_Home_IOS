import Foundation

class AcceptanceItem {
    let address: String?
    let storeName: String?
    let cookingTime: String?
    let latitude: Double?
    let longitude: Double?
    
    
    static var acceptanceItems = [AcceptanceItem]()
    
    init(address:String, storeName:String, latitude:Double, longitude:Double, cookingTime: String){
        self.address = address
        self.storeName = storeName
        self.latitude = latitude
        self.longitude = longitude
        self.cookingTime = cookingTime

    }
}