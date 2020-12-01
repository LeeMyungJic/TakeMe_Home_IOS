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
    var isClickPrepare = false
    
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
    @IBOutlet var PreparePayment: UIButton!
    
    @IBOutlet var address: UILabel!
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var deliveryLabel: UILabel!
    
    var totalPriceValue = 0
    var addressStr: String?
    var deliveryFee = 0
    var payment = ""
    var isPay = ""
    
    
    @IBAction func cardClick(_ sender: Any) {
        
        isClickCash = false
        isClickCard = true
        isClickPrepare = false
        
        Cash.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        Cash.isEnabled = true
        
        Card.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        Card.setTitleColor(.white, for: .disabled)
        Card.isEnabled = false
        
        PreparePayment.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        PreparePayment.isEnabled = true
    }
    @IBAction func cashClick(_ sender: Any) {
        isClickCash = true
        isClickCard = false
        isClickPrepare = false
        
        Cash.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        Cash.setTitleColor(.white, for: .disabled)
        Cash.isEnabled = false
        
        Card.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        Card.isEnabled = true
        
        PreparePayment.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        PreparePayment.isEnabled = true
    }
    @IBAction func preparePay(_ sender: Any) {
        isClickCash = false
        isClickCard = false
        isClickPrepare = true
        
        Cash.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        Cash.isEnabled = true
        
        Card.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        Card.isEnabled = true
        
        PreparePayment.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        PreparePayment.setTitleColor(.white, for: .disabled)
        PreparePayment.isEnabled = false
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
        
        var menuIdCounts : [[String:Any]] = []
        
        for item in LastOrderViewController.menuList {
            menuIdCounts.append(["count" : item.count!, "menuId" : item.menuId!])
        }
        if(isClickPrepare) {
            isPay = "COMPLITE"
            payment = "CARD"
        }
        else {
            isPay = "NONE"
            if(isClickCard) {
                payment = "CARD"
            }
            else if(isClickCash) {
                payment = "CASH"
            }
        }
        
        if !isClickCard, !isClickCash, !isClickPrepare {
            
            let msg = UIAlertController(title: "", message: "결제수단을 선택해 주세요", preferredStyle: .alert)
            let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
            })
            //Alert에 이벤트 연결
            msg.addAction(YES)
            //Alert 호출
            self.present(msg, animated: true, completion: nil)
            
        }
        
        else {
            let param = ["customerId": CustomerOrderViewController.userId!, "menuIdCounts" : ["menuIdCounts" : menuIdCounts], "paymentStatus": self.isPay, "paymentType": self.payment, "requiredTime" : 40 ,"restaurantId" : StoreDetailViewController.restaurantId!, "totalPrice" : self.totalPriceValue + self.deliveryFee] as? [String : Any]
            
            Post(param: param!, url: url!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
