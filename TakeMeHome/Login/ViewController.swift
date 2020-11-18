//
//  ViewController.swift
//  TakeMeHome
//
//  Created by 이명직 on 2020/09/22.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var titleLable: UILabel!
    
    let person = ["점주", "라이더", "사용자"]
    
    @IBOutlet var idStr: UITextField!
    @IBOutlet var passStr: UITextField!
    @IBOutlet var personStr: UITextField!
    
    var loginBool : Bool = false
    var select : String?
    var ident : String?
    var token : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //bbb()
        abc()
        // Do any additional setup after loading the view.
        let border = CALayer()
        
        let width = CGFloat(1.0)
        
        border.borderColor = UIColor.lightGray.cgColor
        
        border.frame = CGRect(x: 0, y: personStr
                                .frame.size.height - width, width:  personStr.frame.size.width, height: personStr.frame.size.height)
        
        
        
        border.borderWidth = width
        
        personStr.layer.addSublayer(border)
        
        personStr.layer.masksToBounds = true
        
        
        
        idStr.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        passStr.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        personStr.attributedPlaceholder = NSAttributedString(string: "회원 유형을 선택하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        createPickerView()
        dismissPickerView()
    }
  
    func abc() {
        print("ABC ABC ABC")
        let url = URL(string: NetWorkController.baseUrl + "/api/v1/orders/reception")
        let array = [["menuId": 1, "count": 1]]
        
        //var menuIdCounts : [String:menuIdCountsArray]?
        var menuIdCounts : [[String:Any]] = []
      
        
        var array1 : NSArray = [array]
        var array2 = ["menuIdCounts":array1]
        
        for item in LastOrderViewController.menuList {
            menuIdCounts.append(["count" : item.count!, "menuId" : item.menuId!])
        }
        
        
        //let param = ["customId": 1, "menuIdCounts" : ["menuIdCounts": ["count":1, "menuId":1]], "paymentStatus": "COMPLITE", "paymentType": "CARD", "restaurantId" : 1, "totalPrice" : 2000] as [String : Any]
        let param1 = ["customId": 1, "menuIdCounts" : ["menuIdCounts" : array], "paymentStatus": "COMPLITE", "paymentType": "CARD", "restaurantId" : 1, "totalPrice" : 2000] as [String : Any]
        Post(param: param1, url: url!)
    }
    
    func bbb() {
        let task = URLSession.shared.dataTask(with: URL(string: NetWorkController.baseUrl + "/api/v1/orders/1")!) { (data, response, error) in
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
                                    
                                    if let temp = i as? NSDictionary {
                                        
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
                                            
                                                    print(temp)
                                                    print(countTemp)
                                                    
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
            
        }
        // Json Parsing
        
        
        task.resume()
    }

    
    
    
    
    @IBAction func Join(_ sender: Any) {
        let addStore = self.storyboard?.instantiateViewController(withIdentifier: "JoinViewController")
        self.present(addStore!, animated: true, completion: nil)
    }
    
    
    
    @IBAction func Login(_ sender: Any) {
        //, "token":token
        var url = URL(string: "")
        var param = ["email":idStr.text, "password":passStr.text] as [String:Any]
        switch personStr.text {
        case "라이더":
            url = URL(string: NetWorkController.baseUrl + "/api/v1/riders/login")
            select = "Rider"
            ident = "TabBar"
        case "점주":
            url = URL(string: NetWorkController.baseUrl + "/api/v1/owners/login")
            select = "Owner"
            ident = select
        case "사용자":
            url = URL(string: NetWorkController.baseUrl + "/api/v1/customers/login")
            select = "Customer"
            ident = select
        default:
            print()
        }
        if let person = personStr.text, let urlT = url {
            login(param: param, url: urlT, isGet: true, person: person)
            
        }
        else {
            print("가입 유형을 선택하세요")
        }
        
        //        orderFindResponses =     (
        //                    {
        //                menuNameCounts =             {
        //                    menuNameCounts =                 (
        //                                            {
        //                            count = 2;
        //                            name = "\Uc544\Uba54\Ub9ac\Uce74\Ub178";
        //                        },
        //                                            {
        //                            count = 1;
        //                            name = "\Uc544\Uc774\Uc2a4\Ud2f0";
        //                        },
        //                                            {
        //                            count = 3;
        //                            name = "\Ubc84\Ube14\Ud2f0";
        //                        }
        //                    );
        //                };
        //                orderCustomer =             {
        //                    name = string;
        //                    phoneNumber = string;
        //                };
        //                orderDelivery =             {
        //                    address = string;
        //                    distance = 0;
        //                    price = 45000;
        //                    status = NONE;
        //                };
        //                orderRestaurant =             {
        //                    address = "\Ub9cc\Uc2181\Ub3d9";
        //                    name = "\Uc2a4\Ud0c0\Ubc85\Uc2a4";
        //                    number = "032 473 2141";
        //                };
        //                orderRider = "<null>";
        //                orderStatus = ORDER;
        //                paymentStatus = COMPLITE;
        //                paymentType = CARD;
        //                totalPrice = 0;
        //            },
        //                    {
        //                menuNameCounts =             {
        //                    menuNameCounts =                 (
        //                                            {
        //                            count = 3;
        //                            name = "\Uc544\Uba54\Ub9ac\Uce74\Ub178";
        //                        },
        //                                            {
        //                            count = 2;
        //                            name = "\Ubc84\Ube14\Ud2f0";
        //                        }
        //                    );
        //                };
        //                orderCustomer =             {
        //                    name = string;
        //                    phoneNumber = string;
        //                };
        //                orderDelivery =             {
        //                    address = string;
        //                    distance = 0;
        //                    price = 45000;
        //                    status = NONE;
        //                };
        //                orderRestaurant =             {
        //                    address = "\Ub9cc\Uc2181\Ub3d9";
        //                    name = "\Uc2a4\Ud0c0\Ubc85\Uc2a4";
        //                    number = "032 473 2141";
        //                };
        //                orderRider = "<null>";
        //                orderStatus = ORDER;
        //                paymentStatus = COMPLITE;
        //                paymentType = CARD;
        //                totalPrice = 0;
        //            }
        //        );
        
        
        
        
        //                guard let id = idStr.text, !id.isEmpty else { return }
        //                        guard let password = passStr.text, !password.isEmpty else { return }
        //
        //                        // Model이 해당 유저를 가지고 있는지 검사
        //                        var loginSuccess: Bool = false
        //
        //                if idStr.text == id, passStr.text == password {
        //                    loginSuccess = true
        //                }
        //
        //                if loginSuccess {
        //                    print("로그인 성공")
        //                    guard let main = self.storyboard?.instantiateViewController(identifier: "TabBar") else{return}
        //                    self.present(main, animated: true)
        //                }else {
        //                    UIView.animate(withDuration: 0.2, animations: {
        //                        self.idStr.frame.origin.x -= 10
        //                        self.passStr.frame.origin.x -= 10
        //                    }, completion: { _ in
        //                        UIView.animate(withDuration: 0.2, animations: {
        //                            self.idStr.frame.origin.x += 20
        //                            self.passStr.frame.origin.x += 20
        //                        }, completion: { _ in
        //                            UIView.animate(withDuration: 0.2, animations: {
        //                                self.idStr.frame.origin.x -= 10
        //                                self.passStr.frame.origin.x -= 10
        //                            })
        //                        })
        //                    })
        //                }
        //        if(idStr.text == "a") {
        //            let storyboard = UIStoryboard.init(name: "Customer", bundle: nil)
        //
        //            let popUp = storyboard.instantiateViewController(identifier: "Customer")
        //            popUp.modalPresentationStyle = .overCurrentContext
        //            popUp.modalTransitionStyle = .crossDissolve
        //
        //            self.present(popUp, animated: true, completion: nil)
        //        }
        //        else {
        //            let storyboard = UIStoryboard.init(name: "Rider", bundle: nil)
        //
        //            let popUp = storyboard.instantiateViewController(identifier: "TabBar")
        //            popUp.modalPresentationStyle = .overCurrentContext
        //            popUp.modalTransitionStyle = .crossDissolve
        //
        //            self.present(popUp, animated: true, completion: nil)
        //        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return person.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return person[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        personStr.text = person[row]
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        personStr.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(ButtonAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        personStr.inputAccessoryView = toolBar
    }
    
    @objc func ButtonAction() {
        
        // 피커뷰 내리기
        personStr.resignFirstResponder()
    }
    
    func login(param: [String:Any], url: URL, isGet: Bool = false, person: String = "") {
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        // 4. HTTP 메시지에 포함될 헤더 설정
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
        
        // 5. URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            //print("responseString = \(responseString)")
            if isGet {
                
                do {
                    // JSONSerialization로 데이터 변환하기
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
                    {
                        
                        if let temp2 = json["data"] as? Int {
                            
                            switch person {
                            case "라이더":
                                CallViewController.riderId = temp2
                            case "사용자":
                                CustomerOrderViewController.userId = temp2
                            case "점주":
                                ManagerViewController.ownerId = temp2
                            default:
                                print("")
                            }
                            self.move()
                        }
                    }
                    
                }
                catch {
                    print("JSON 파상 에러")
                    
                }
                print("JSON 파싱 완료") // 메일 쓰레드에서 화면 갱신 DispatchQueue.main.async { self.tvMovie.reloadData() }
                
            }
            
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직
            
        }
        // POST 전송
        task.resume()
    }
    
    func move() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard.init(name: self.select!, bundle: nil)
            
            let popUp = storyboard.instantiateViewController(identifier: self.ident!)
            popUp.modalPresentationStyle = .overCurrentContext
            popUp.modalTransitionStyle = .crossDissolve
            
            self.present(popUp, animated: true, completion: nil)
        }
    }
    
}

