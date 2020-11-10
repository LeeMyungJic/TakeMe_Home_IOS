//
//  RequestViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/22.
//

import UIKit

class AcceptanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var AcceptanceView: UITableView!
    
    var callList = [getCall]()
    
    var selectedIndex: Int?
    
    func getItems() {
        callList = [getCall]()
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/orders/riders/" + "\(CallViewController.riderId!)")!) { (data, response, error) in
            print("연결!")
            if let dataJson = data {
                print(dataJson)
                do {
                    // JSONSerialization로 데이터 변환하기
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        
                        //print(json["data"] as? [String:Any])
                        if let temp = json["data"] as? NSArray{
                            print(temp)
//                            if let temp2 = temp["orderFindRequestStatusResponses"] as? NSArray {
                                print("=================================================")
                                for i in temp {
                                    var address: String?
                                    var price: Int?
                                    var number: String?
                                    var payment: String?
                                    var distance: Double?
                                    var storeAddress: String?
                                    var storeNumber: String?
                                    var payStatus: String?
                                    
                                    var status : String?
                                    if let temp = i as? NSDictionary {
                                        print("=======================================================")
                                        if let orderCustomer = temp["orderCustomer"] as? [String:Any]{
                                            print("orderCustomer")
                                            print("고객명 : " + "\(orderCustomer["name"] as! String)")
                                            print("전화번호 : " + "\(orderCustomer["phoneNumber"] as! String)")
                                            number = orderCustomer["phoneNumber"] as! String
                                        }
                                        if let orderDelivery = temp["orderDelivery"] as? [String:Any]{
                                            print("orderDelivery")
                                            print("배달 주소 : " + "\(orderDelivery["address"] as! String)")
                                            distance = orderDelivery["distance"] as! Double
                                            address = orderDelivery["address"] as! String
                                            price = orderDelivery["price"] as! Int
                                            
                                            
                                            status = orderDelivery["status"] as! String
                                        }
                                        if let orderRestaurant = temp["orderRestaurant"] as? [String:Any]{
                                            print("orderRestaurant")
                                            print("가게 주소 : " + "\(orderRestaurant["address"] as! String)")
                                            print("가게 이름 : " + "\(orderRestaurant["name"] as! String)")
                                            
                                            storeAddress = orderRestaurant["address"] as! String
                                            print("가게 번호 : " + "\(orderRestaurant["number"] as! String)")
                                        }
                                        if let orderRider = temp["orderRider"] as? [String:Any]{
                                            print(orderRider)
                                            print("라이더 이름 : " + "\(orderRider["name"] as? String)")
                                            print("라이더 번호 : " + "\(orderRider["phoneNumber"] as? String)")
                                            
                                        }
                                        if let paymentType = temp["paymentType"] {
                                            payment = paymentType as? String
                                        }
                                        if let paymentStatus = temp["paymentStatus"] {
                                            payStatus = paymentStatus as? String
                                        }
                                        
                                        
                                            self.callList.append(getCall(address: address, price: price, number: number, payment: payment, distance: distance, storeAddress: storeAddress, storeNumber: storeNumber, payStatus: payStatus))
                                        
                                        
                                        
                                        
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
                self.AcceptanceView.reloadData()
            }
            
        }
        // Json Parsing
        
        
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "OderView", bundle: nil)
        
        selectedIndex = indexPath.row
        
        let popUp = storyboard.instantiateViewController(identifier: "OderViewController")
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        
        let temp = popUp as? OderViewController
        
        temp?.addressStr = callList[indexPath.row].address!
        temp?.arrivalTimeStr = callList[indexPath.row].payStatus!
        temp?.methodOfPaymentStr = callList[indexPath.row].payment!
        temp?.priceStr = "\(callList[indexPath.row].price!) 원"
        temp?.requirementStr = callList[indexPath.row].number!
        
        
        
        
        
        self.present(popUp, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = AcceptanceView.dequeueReusableCell(withIdentifier: "AcceptanceCell", for: indexPath) as! AcceptanceCell
        cell.nameStr.text = "배달지 : " + callList[indexPath.row].address!
        cell.addressStr.text = "결제 여부 : " + callList[indexPath.row].payStatus!
        cell.Time.text = "결제 금액 : " + "\(callList[indexPath.row].price!)"
        
        //셀 디자인
        cell.stack.layer.borderColor = #colorLiteral(red: 0.4344803691, green: 0.5318876505, blue: 1, alpha: 1)
        //테두리 두께
        cell.stack.layer.borderWidth = 1
        // 모서리 둥글게
        cell.stack.layer.cornerRadius = 5
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil) as! AcceptanceCell
            cell.stack.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        AcceptanceView.dataSource = self
        AcceptanceView.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    // Call에서 수락한 아이템 최신화
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getItems()
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

struct getCall {
    var address: String?
    var price: Int?
    var number: String?
    var payment: String?
    var distance: Double?
    var storeAddress: String?
    var storeNumber: String?
    var payStatus: String?
    
}
