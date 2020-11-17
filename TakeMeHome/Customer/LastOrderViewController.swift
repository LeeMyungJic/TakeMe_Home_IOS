//
//  LastOrderViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/10.
//

import UIKit

class LastOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isClickCard = false
    var isClickCash = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LastOrderViewController.menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableMain.dequeueReusableCell(withIdentifier: "LastOrderCell", for: indexPath) as! LastOrderCell
        
        
        cell.nameLabel.text = "\(LastOrderViewController.menuList[indexPath.row].name!) x \(LastOrderViewController.menuList[indexPath.row].count!)"
        cell.priceLabel.text = "\(LastOrderViewController.menuList[indexPath.row].count! * LastOrderViewController.price[indexPath.row]) 원"
        return cell
    }
    
    
    @IBOutlet var Card: UIButton!
    @IBOutlet var Cash: UIButton!
    @IBOutlet var address: UILabel!
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var deliveryLabel: UILabel!
    
    var totalPriceValue = 0
    var addressStr: String?
    var deliveryFee = 0
    
    
    @IBAction func cardClick(_ sender: Any) {
        if(isClickCash) {
            isClickCash = false
            Cash.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            Cash.isEnabled = true
        }
        isClickCard = true
        Card.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        Card.isEnabled = false
    }
    @IBAction func cashClick(_ sender: Any) {
        if(isClickCard) {
            isClickCard = false
            Card.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            Card.isEnabled = true
        }
        isClickCash = true
        Cash.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        Cash.isEnabled = false
    }
    
    
    static var menuList = [menuAndCount]()
    static var price = [Int]()
    
    @IBOutlet var TableMain: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        TableMain.delegate = self
        TableMain.dataSource = self
        TableMain.estimatedRowHeight = 44.0
        TableMain.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAddress()
        address.text = addressStr
        calculate()
    }
    
    func calculate() {
        for i in 0...LastOrderViewController.price.count - 1 {
            print(i)
            totalPriceValue += LastOrderViewController.menuList[i].count! * LastOrderViewController.price[i]
        }
        
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/restaurants/restaurant/\(StoreDetailViewController.restaurantId!)/\(CustomerOrderViewController.userId!)/distance")!) { (data, response, error) in
            if let dataJson = data {
                
                do {
                    // JSONSerialization로 데이터 변환하기
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
//                        if let temp = json["address"] as? [String:Any] {
//                            print("data!!")
//                            self.addressStr = temp as? String
//                        }
                        
                        if let temp = json["data"] as? [String:Any] {
                            print("data!!")
                            guard let price = temp["price"] as? Int else {
                                return
                            }
                            print("price!!")
                            self.deliveryFee = price
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
                self.deliveryLabel.text = "\(self.deliveryFee) 원"
                self.totalPrice.text = "\(self.totalPriceValue + self.deliveryFee) 원"
            }
            
        }
        task.resume()
        
    }
    
    func getAddress() {
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/customers/customer/" + "\(CustomerOrderViewController.userId!)")!) { (data, response, error) in
            if let dataJson = data {
                
                do {
                    // JSONSerialization로 데이터 변환하기
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
//                        if let temp = json["address"] as? [String:Any] {
//                            print("data!!")
//                            self.addressStr = temp as? String
//                        }
                        
                        if let temp = json["data"] as? [String:Any] {
                            print("data!!")
                            self.addressStr = temp["address"] as? String
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
                self.address.text = self.addressStr
            }
            
        }
        task.resume()
    }
    
    
    
    
    @IBAction func Order(_ sender: Any) {
        
        let url = URL(string: NetWorkController.baseUrl + "/api/v1/orders/reception")
        let array = [["count": 1, "menuId": 1], ["count": 2, "menuId": 1]]
        
        
        let jsonString = convertIntoJSONString(arrayObject: array)
        
        
        
        //var menuIdCounts : [String:menuIdCountsArray]?
        var menuIdCounts : [[String:Any]] = []
        print(menuIdCounts)
        
        for item in LastOrderViewController.menuList {
            menuIdCounts.append(["count" : item.count!, "menuId" : item.menuId!])
        }
        print(menuIdCounts)
        
        
        let param = ["customId": CustomerOrderViewController.userId!, "deliveryOrderRequest": ["distance": 0, "price": 2000], "menuIdCounts" : ["menuIdCounts": [
            [
                "count" : 1,
                "menuId": 2,
            ],
            [
                "count" : 4,
                "menuId": 1,
            ]
        ]], "paymentStatus": "COMPLITE", "paymentType": "CARD", "restaurantId" : StoreDetailViewController.restaurantId!, "totalPrice" : 0] as [String : Any]
        print(param)
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
    
    /*
     if let dataJson = data {
         do {
             // JSONSerialization로 데이터 변환하기
             if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
             {
                 print(json)
                 //print(json["data"] as? [String:Any])
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
                             
                         }
                     }
                 }
     */
    
}
