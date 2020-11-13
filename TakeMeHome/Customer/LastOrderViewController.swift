//
//  LastOrderViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/10.
//

import UIKit

class LastOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LastOrderViewController.menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableMain.dequeueReusableCell(withIdentifier: "LastOrderCell", for: indexPath) as! LastOrderCell
        
        
        cell.nameLabel.text = "\(LastOrderViewController.menuList[indexPath.row].name!) x \(LastOrderViewController.menuList[indexPath.row].count!)"
        cell.priceLabel.text = "\(LastOrderViewController.menuList[indexPath.row].count! * LastOrderViewController.price[indexPath.row]) 원"
        return cell
    }
    
    
    @IBOutlet var address: UILabel!
    @IBOutlet var totalPrice: UILabel!
    
    var totalPriceValue = 0
    var addressStr: String?
    
    static var menuList = [menuAndCount]()
    static var price = [Int]()
    
    @IBOutlet var TableMain: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        TableMain.delegate = self
        TableMain.dataSource = self
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
        totalPrice.text = "\(totalPriceValue) 원"
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
