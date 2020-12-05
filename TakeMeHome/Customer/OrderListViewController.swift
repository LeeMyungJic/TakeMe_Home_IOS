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
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOrderList()
    }
    
    func getOrderList() {
        orderList = [customerOrder]()
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/orders" + "\(CustomerOrderViewController.userId)")!) { (data, response, error) in
            if let dataJson = data {
                print(data)
                do {
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        //print(json["data"] as? [String:Any])
                        if let temp = json["data"] as? [String:Any] {
                            if let temp2 = temp["restaurantFindAllResponse"] as? NSArray {
                                for i in temp2 {
                                    if let temp = i as? NSDictionary {
                                        let nameStr = temp["name"] as! String
                                        let idStr = temp["id"] as! Int
                                        self.orderList.append(customerOrder(name: "", price: 1, state: ""))
                                            
                                        
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
//        let submitBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
//                // 비슷한 메서드 주의 : btn.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)
//            self.navigationItem.rightBarButtonItem = submitBtn

    }
    


}

struct customerOrder {
    var name: String?
    var price: Int?
    var state: String?
}
