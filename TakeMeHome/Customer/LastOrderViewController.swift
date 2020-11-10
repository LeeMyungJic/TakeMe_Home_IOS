//
//  LastOrderViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/10.
//

import UIKit

class LastOrderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    /*
     if let temp = json["data"] as? [String:Any] {
         if let temp2 = temp["orderFindResponses"] as? NSArray {
             for i in temp2 {
                 var orderAddress : String?
                 var orderPrice : Int?
                 var orderNumber : String?
                 
                 if let temp = i as? NSDictionary {
                     
                     if let orderCustomer = temp["orderCustomer"] as? [String:Any]{
                         //                                            print("orderCustomer")
                         //                                            print("고객명 : " + "\(orderCustomer["name"] as! String)")
                         //                                            print("전화번호 : " + "\(orderCustomer["phoneNumber"] as! String)")
                         orderNumber = orderCustomer["phoneNumber"] as! String
                     }
                     if let orderDelivery = temp["orderDelivery"] as? [String:Any]{
                         //print("orderDelivery")
                         //print("배달 주소 : " + "\(orderDelivery["address"] as! String)")
                         //print("거리 : " + "\(orderDelivery["distance"] as! Int)")
                         //print("가격 : " + "\(orderDelivery["price"] as! Int)")
                         orderAddress = orderDelivery["address"] as! String
                         orderPrice = orderDelivery["price"] as! Int
                         //print("상태 : " + "\(orderDelivery["status"] as! REQUEST)")
                     }
                     if let orderRestaurant = temp["orderRestaurant"] as? [String:Any]{
                         //print("orderRestaurant")
                         //print("가게 주소 : " + "\(orderRestaurant["address"] as! String)")
                         //print("가게 이름 : " + "\(orderRestaurant["name"] as! String)")
                         //print("가게 번호 : " + "\(orderRestaurant["number"] as! String)")
                         //print("상태 : " + "\(orderDelivery["status"] as! REQUEST)")
                     }
                     if let orderRider = temp["orderRider"] as? [String:Any]{
                         //print(orderRider)
                         //print("라이더 이름 : " + "\(orderRider["name"] as? String)")
                         //print("라이더 번호 : " + "\(orderRider["phoneNumber"] as? String)")
                         
                     }
                     if let orderStatus = temp["orderStatus"] as? [String:Any]{
                         
                         
                     }
                     if let menuNameCounts = temp["menuNameCounts"] as? [String:Any]{
                         print("menuNameCounts")
                         if let menuNameCountsT = menuNameCounts["menuNameCounts"] as? [[String:Any]]{
                             print("menuNameCountsT")
                             var orderProductName = ""
                             
                             for i in menuNameCountsT {
                                 for item in i{
                                     //print(item["name"] as? String ?? "")
                                     //print(item.value)
                                 }
                                 var temp = i["name"] as? String ?? ""
                                 var countTemp = i["count"] as? Int
                         
                                     orderProductName += temp + " x" + "\(countTemp!)\n"
                                 
                             }
                             self.callList.append(order(productName: orderProductName, address: orderAddress, price: orderPrice, customerNumber: orderNumber))
                             print("")
                         }
                     }
                     
                 }
                 
     */
    
    @IBAction func Order(_ sender: Any) {
        
        let url = URL(string: NetWorkController.baseUrl + "/api/v1/orders/reception")
        let array = [["count": 1, "menuId": 1], ["count": 2, "menuId": 1]]

        
        let jsonString = convertIntoJSONString(arrayObject: array)
        

        
        //var menuIdCounts : [String:menuIdCountsArray]?
        var menuIdCounts : [String:Array<Dictionary<String,Any>>] = ["menuIdCounts":[["count":1, "menuId":1],["count":1, "menuId":1]]]
        print(menuIdCounts)
        
        
        let param = ["customId": CustomerOrderViewController.userId!, "deliveryOrderRequest": ["distance": 0, "price": 2000], "menuIdCounts" : ["menuIdCounts" : menuIdCounts], "paymentStatus": "COMPLITE", "paymentType": "CARD", "restaurantId" : StoreDetailViewController.restaurantId!, "totalPrice" : 0] as [String : Any]
        Post(param: param, url: url!)
        
    }
    func convertIntoJSONString(arrayObject: [Any]) -> String? {

            do {
                let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
                if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    return jsonString as String
                }
                
            } catch let error as NSError {
                print("Array convertIntoJSON - \(error.description)")
            }
            return nil
        }
    
}
//
//struct menuIdCounts {
//    var count : Int?
//    var manu : Int?
//}

