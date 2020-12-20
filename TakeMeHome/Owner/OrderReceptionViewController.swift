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
                                    var orderStatus : String?
                                    if let temp = i as? NSDictionary {
                                        
                                        orderStatus = temp["orderStatus"] as! String
                                        
                                        if let orderCustomer = temp["orderCustomer"] as? [String:Any]{
                                         orderNumber = orderCustomer["phoneNumber"] as! String
                                        }
                                        if let orderDelivery = temp["orderDelivery"] as? [String:Any]{
                                           
                                            orderAddress = orderDelivery["address"] as! String
                                            orderPrice = orderDelivery["price"] as! Int
                                           
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
                                                        
                                                        orderProductName += menuNameCountsT[0]["name"] as? String ?? "" + ","
                                                    }
                                                }
                                            }
                                        }
                                        print(orderStatus ?? "nil" + "===========")
                                        if(orderStatus == "RECEPTION") {
                                            self.orderList.append(order(productName: orderProductName, address: orderAddress, price: orderPrice, customerNumber: orderNumber))
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
        
        
        cell.address.text = "주소 : " + orderList[indexPath.row].address!
        cell.name.text = "메뉴 : " + orderList[indexPath.row].productName!
        cell.price.text = "가격 : \(orderList[indexPath.row].price!) 원"
        cell.number.text = "고객 번호 : \(orderList[indexPath.row].customerNumber!)"
        
        //셀 디자인
        cell.stack.layer.borderColor = #colorLiteral(red: 0.4344803691, green: 0.5318876505, blue: 1, alpha: 1)
        //테두리 두께
        cell.stack.layer.borderWidth = 1
        // 모서리 둥글게
        cell.stack.layer.cornerRadius = 5
        
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

