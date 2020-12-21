//
//  OrderReceptionViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/09.
//

import UIKit

class OrderReceptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var orderList = [order]()
    
    func getOrder() {
        orderList = [order]()
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/orders/" + "\(ManagerCallViewController.restaurantId)")!) { (data, response, error) in
            print("연결!")
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
                                    var orderId : Int?
                                    var orderStatus : String?
                                    
                                    if let temp = i as? NSDictionary {
                                        
                                        orderId = temp["orderId"] as! Int
                                        orderStatus = temp["orderStatus"] as! String
                                        if let orderCustomer = temp["orderCustomer"] as? [String:Any]{
                                           
                                            orderNumber = orderCustomer["phoneNumber"] as! String
                                        }
                                        if let orderDelivery = temp["orderDelivery"] as? [String:Any]{
                                           
                                            orderAddress = orderDelivery["address"] as! String
                            
                                          
                                        }
                                        
                                        orderPrice = temp["totalPrice"] as! Int
                                        
                                   
                                        if let menuNameCounts = temp["menuNameCounts"] as? [String:Any]{
                                            if let menuNameCountsT = menuNameCounts["menuNameCounts"] as? [[String:Any]]{
                                                
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
                                                
                                                if(orderStatus == "RECEPTION") {
                                                self.orderList.append(order(productName: orderProductName, address: orderAddress, price: orderPrice, customerNumber: orderNumber, orderId: orderId))
                                                
                                                }
                                            }
                                        }
                                        
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
                self.TableMain.reloadData()
            }
            
        }
        // Json Parsing
        
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TableMain.dequeueReusableCell(withIdentifier: "OrderReCeptionCell", for: indexPath) as! OrderReCeptionCell
        
        
        cell.address.text = orderList[indexPath.row].address!
        cell.name.text = orderList[indexPath.row].productName!
        cell.price.text = "\(orderList[indexPath.row].price!) 원"
        cell.number.text = orderList[indexPath.row].customerNumber!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msg = UIAlertController(title: orderList[indexPath.row].address, message: "주문을 접수하시겠습니까?", preferredStyle: .alert)
        
        
        let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
            self.YesClick(didSelectRowAt: indexPath)
        })
        
        //Alert에 부여할 No이벤트 선언
        let NO = UIAlertAction(title: "취소", style: .cancel) { (action) -> Void in
            self.NoClick()
        }
        
        //Alert에 이벤트 연결
        msg.addAction(YES)
        msg.addAction(NO)
        
        //Alert 호출
        self.present(msg, animated: true, completion: nil)
    }
    
    func YesClick(didSelectRowAt indexPath: IndexPath)
    {
        print("YES Click")
        
    }
    
    func NoClick()
    {
        
    }
    
    
    @IBOutlet var TableMain: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        TableMain.delegate = self
        TableMain.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOrder()
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

