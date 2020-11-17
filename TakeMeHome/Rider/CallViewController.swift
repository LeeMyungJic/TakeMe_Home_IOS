//
//  CallViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/22.
//

import UIKit

class CallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tempIndex:IndexPath? = nil
    var itemData:Array<Dictionary<String, Any>>?
    static var riderId : Int?
    
    var callList = [call]()
    
    var selectedIndex : IndexPath?
    var mTimer:Timer?
    static var addCount = 0
    var count = 0
    let interval = 2.0
    let timeSelector: Selector = #selector(CallViewController.timerCallback)
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    // Call 아이템 가져오기
    func getItems() {
        callList = [call]()
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/orders/status/request")!) { (data, response, error) in
            print("연결!")
            if let dataJson = data {
                print(dataJson)
                do {
                    // JSONSerialization로 데이터 변환하기
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        print(json)
                        //print(json["data"] as? [String:Any])
                        if let temp = json["data"] as? [String:Any] {
                            print(temp)
                            if let temp2 = temp["orderFindRequestStatusResponses"] as? NSArray {
                                print("orderFindRequestStatusResponses")
                                for i in temp2 {
                                    var orderStore : String?
                                    var orderAddress : String?
                                    var orderDistance : Double?
                                    var status : String?
                                    var orderId: Int?
                                    if let temp = i as? NSDictionary {
                                        
                                        if let orderCustomer = temp["orderCustomer"] as? [String:Any]{
                                            print("orderCustomer")
                                            print("고객명 : " + "\(orderCustomer["name"] as! String)")
                                            print("전화번호 : " + "\(orderCustomer["phoneNumber"] as! String)")
                                           // orderNumber = orderCustomer["phoneNumber"] as! String
                                        }
                                        if let orderDelivery = temp["orderDelivery"] as? [String:Any]{
                                            print("orderDelivery")
                                            print("배달 주소 : " + "\(orderDelivery["address"] as! String)")
                                            orderDistance = orderDelivery["distance"] as! Double
                                            //print("가격 : " + "\(orderDelivery["price"] as! Int)")
                                            
                                            
                                            status = orderDelivery["status"] as! String
                                        }
                                        if let orderRestaurant = temp["orderRestaurant"] as? [String:Any]{
                                            print("orderRestaurant")
                                            print("가게 주소 : " + "\(orderRestaurant["address"] as! String)")
                                            print("가게 이름 : " + "\(orderRestaurant["name"] as! String)")
                                            
                                            orderStore = orderRestaurant["name"] as! String
                                            orderAddress = orderRestaurant["address"] as! String
                                            print("가게 번호 : " + "\(orderRestaurant["number"] as! String)")
                                        }
                                        if let orderRider = temp["orderRider"] as? [String:Any]{
                                            print(orderRider)
                                            print("라이더 이름 : " + "\(orderRider["name"] as? String)")
                                            print("라이더 번호 : " + "\(orderRider["phoneNumber"] as? String)")
                                            
                                        }
                                        if let orderNum = temp["orderId"] as? Int {
                                            orderId = orderNum
                                        }
                                        if status == "REQUEST" {
                                            self.callList.append(call(storeName: orderStore, storeAddress: orderAddress, storeDistace: orderDistance, orderId: orderId))
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
                self.TableViewMain.reloadData()
            }
            
        }
        // Json Parsing
        
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = TableViewMain.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
        /*
         let inx = indexPath.row
         if let receivedItem = itemData {
         let row = receivedItem[indexPath.row]
         if let r = row as? Dictionary<String, Any> {
         // 아이템 각 항목이 있으면 넣어주기
         if let address = r["address"] as? String, let storeName = r["storeName"] as? String, let cookingTime = r["cookingTime"] as? String, let latitude = r["latitude"] as? String, let longitude = r["longitude"] as? String, let oderCode = r["oderCode"] as? String {
         
         cell.storeNameStr.text = storeName
         cell.storeAddress.text = address
         cell.timeStr.text = cookingTime
         
         }
         }
         }
         */
        
        
        cell.storeNameStr.text = "가게 이름 : " + callList[indexPath.row].storeName!
        cell.storeAddress.text = "가게 주소 : " + callList[indexPath.row].storeAddress!
        cell.timeStr.text = "배달지까지 거리 : \(callList[indexPath.row].storeDistace!)Km"
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msg = UIAlertController(title: callList[indexPath.row].storeName, message: "접수하시겠습니까?", preferredStyle: .alert)
        
        
        let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
            self.selectedIndex = indexPath
            self.YesClick(didSelectRowAt:self.callList[indexPath.row].orderId!)
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
    
    func YesClick(didSelectRowAt:Int)
    {
        let url = URL(string: NetWorkController.baseUrl + "/api/v1/orders/order/" + "\(didSelectRowAt)" + "/assigned/" + "\(CallViewController.riderId!)")
        let param = [:] as? [String:Any]
        Put(param: param!, url: url!)
        
        TableViewMain.beginUpdates()
        TableViewMain.deleteRows(at: [IndexPath(row: selectedIndex!.row, section: 0)], with: .automatic)
        callList.remove(at: selectedIndex!.row)
        TableViewMain.endUpdates()
    }
    
    func NoClick()
    {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        
        //        if let timer = mTimer {
        //            //timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
        //            if !timer.isValid {
        //                /** 1초마다 timerCallback함수를 호출하는 타이머 */
        //                mTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        //            }
        //        }else{
        //            //timer 객체가 nil 인 경우에 객체를 생성하고 타이머를 시작한다
        //            /** 1초마다 timerCallback함수를 호출하는 타이머 */
        //            mTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        //        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getItems()
    }
    
    @objc func timerCallback() {
        
        print("타임 콜백 !!")
        
        TableViewMain.beginUpdates()
        
        TableViewMain.insertRows(at: [IndexPath(row: Order.Orders.count - 1, section: 0)], with: .automatic)
        TableViewMain.endUpdates()
    }
}

struct call {
    var storeName: String?
    var storeAddress: String?
    var storeDistace: Double?
    var orderId: Int?
}

