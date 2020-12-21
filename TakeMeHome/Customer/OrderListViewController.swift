//
//  OrderListViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/11/13.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var orderList = [customerOrder]()
    
    @IBOutlet var TableMain: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableMain.dequeueReusableCell(withIdentifier: "customerOrderListCell", for: indexPath) as! customerOrderListCell
        cell.name.text = orderList[indexPath.row].name!
        cell.price.text = "\(orderList[indexPath.row].price!)"
        if orderList[indexPath.row].state == "RECEPTION" {
            cell.status.text = "조리중"
        }
        else if orderList[indexPath.row].state == "COMPLETE" {
            cell.status.text = "배달중"
        }
        cell.time.text = orderList[indexPath.row].time!
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOrderList()
    }
    
    func getOrderList() {
        orderList = [customerOrder]()
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/orders/customers/" + "\(CustomerOrderViewController.userId!)")!) { (data, response, error) in
            if let dataJson = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        
                        
                        if let temp2 = json["data"] as? NSArray {
                            print("tttttttttttt22222tt")
                            for i in temp2 {
                                if let temp = i as? NSDictionary {
                                    print("NSDICTIONARY !!!!")
                                    var getPrice = 0
                                    var getTime = ""
                                    var getState = ""
                                    
                                    
                                    
                                    if let totalPrice = temp["totalPrice"] as? Int {
                                        print("price !!!!!")
                                        getPrice = totalPrice
                                    }
                                    if let orderStatus = temp["orderStatus"] as? String {
                                        print("status !!!!!")
                                        getState = orderStatus
                                    }
                                    
                                    if let time = temp["orderTime"] as? String {
                                        print("Time !!!!!!!!")
                                        getTime = time
                                    }
                                    
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
                                            
                                           
                                            self.orderList.append(customerOrder(name: orderProductName, time: getTime, price: getPrice, state: getState))
                                            
                                            print("카운트 : \(self.orderList.count)")
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
        task.resume()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableMain.delegate = self
        TableMain.dataSource = self
//        let submitBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
//                // 비슷한 메서드 주의 : btn.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)
//            self.navigationItem.rightBarButtonItem = submitBtn

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        getOrderList()
    }


}

struct customerOrder {
    var name: String?
    var time: String?
    var price: Int?
    var state: String?
}
