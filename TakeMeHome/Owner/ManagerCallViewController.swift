//
//  ManagerCallViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/10/30.
//

import UIKit
import Alamofire
import SwiftyJSON

class ManagerCallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var TableViewMain: UITableView!
    
    static var restaurantId : Int = 0;
    var callList = [order]()
    
    func getCall() {
        callList = [order]()
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/orders/" + "\(ManagerCallViewController.restaurantId)")!) { (data, response, error) in
            
            if let dataJson = data {
                
                do {
                    // JSONSerialization로 데이터 변환하기
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        //print(json["data"] as? [String:Any])
                        if let temp = json["data"] as? [String:Any] {
                            if let temp2 = temp["orderFindResponses"] as? NSArray {
                                for i in temp2 {
                                    var orderAddress : String?
                                    var orderPrice : Int?
                                    var orderNumber : String?
                                    var orderProductName = ""
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
                                                for i in 0...menuNameCountsT.count {
                                                    if (i == menuNameCountsT.count - 1) {
                                                        orderProductName += menuNameCountsT[0]["name"] as? String ?? ""
                                                    }
                                                    else {
                                                        print("상품명 : " + "\(menuNameCountsT[0]["name"] as? String)")
                                                        orderProductName += menuNameCountsT[0]["name"] as? String ?? "" + ","
                                                    }
                                                }
                                            }
                                        }
                                        
                                        self.callList.append(order(productName: orderProductName, address: orderAddress, price: orderPrice, customerNumber: orderNumber))
                                        print("")
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }
                catch {
                    print("JSON 파상 에러")
                    
                }
                print("JSON 파싱 완료") // 메일 쓰레드에서 화면 갱신 DispatchQueue.main.async { self.tvMovie.reloadData() }
                
            }
            
            
            
            // UI부분이니까 백그라운드 말고 메인에서 실행되도록 !
            DispatchQueue.main.async {
                //reloadData로 데이터를 가져왔으니 쓰라고 통보 ㅎㅎ
                self.TableViewMain.reloadData()
            }
            
        }
        // Json Parsing
        
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return callList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "OderView", bundle: nil)
        
        let popUp = storyboard.instantiateViewController(identifier: "OderViewController")
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        
        let temp = popUp as? OderViewController
        temp?.addressStr = "주소 값"
        temp?.arrivalTimeStr = "도착시간 값"
        
        temp?.requirementStr = callList[indexPath.row].productName!
        temp?.addressStr = callList[indexPath.row].address!
        temp?.priceStr = "\(callList[indexPath.row].price!) 원"
        
        //temp?.methodOfPaymentStr = callList[indexPath.row].methodOfPayment!
        //temp?.requirementStr = callList[indexPath.row].requirement!
        
        self.present(popUp, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TableViewMain.dequeueReusableCell(withIdentifier: "ManagerCallCell", for: indexPath) as! ManagerCallCell
        
        
        cell.address.text = "주소 : " + callList[indexPath.row].address!
        cell.name.text = "메뉴 : " + callList[indexPath.row].productName!
        cell.price.text = "가격 : \(callList[indexPath.row].price!) 원"
        cell.number.text = "고객 번호 : \(callList[indexPath.row].customerNumber!)"
        
        //셀 디자인
        cell.stack.layer.borderColor = #colorLiteral(red: 0.4344803691, green: 0.5318876505, blue: 1, alpha: 1)
        //테두리 두께
        cell.stack.layer.borderWidth = 1
        // 모서리 둥글게
        cell.stack.layer.cornerRadius = 5
        
        // 빈 셀 출력 x
        //        else {
        //            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil) as! ManagerCallCell
        //            cell.stack.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        }
        
        return cell
    }
    
    
    static var getStoreName = "NULL"
    @IBOutlet var StoreName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCall()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
struct order {
    var productName: String?
    var address: String?
    var price: Int?
    var customerNumber: String?
}

//struct order {
//    var orderFindResponses: [String:Any]?
//
//
//struct orderFindResponses {
//    var menuNameCounts: [String:Any]?
//    var orderCustomer: [String:Any]?
//    var orderDelivery: [String:Any]?
//    var orderRestaurant: [String:Any]?
//    var orderRider: [String:Any]?
//    "orderFindResponses": [
//      {
//        "menuNameCounts": {
//          "menuNameCounts": [
//            {
//              "count": 0,
//              "name": "string"
//            }
//          ]
//        },
//        "orderCustomer": {
//          "name": "string",
//          "phoneNumber": "string"
//        },
//        "orderDelivery": {
//          "address": "string",
//          "distance": 0,
//          "price": 0,
//          "status": "REQUEST"
//        },
//        "orderRestaurant": {
//          "address": "string",
//          "name": "string",
//          "number": "string"
//        },
//        "orderRider": {
//          "name": "string",
//          "phoneNumber": "string"
//        },
//        "orderStatus": "REQUEST"
//      }
//    ]
//  }
//}
//}
